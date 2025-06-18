require 'rails_helper'

RSpec.describe DealsController, type: :controller do
  let!(:location1) { create(:location, latitude: 40, longitude: -74) }
  let!(:location2) { create(:location, latitude: 30, longitude: -120) }

  let!(:deal_location1) { create(:deal_location, deal: deal1, location: location1) }
  let!(:deal_location2) { create(:deal_location, deal: deal2, location: location2) }

  let!(:deal1) { create(:deal, :not_expired, :featured, category: 'electronics', subcategory: 'phones', discount_price: 100.0) }
  let!(:deal2) { create(:deal, :not_expired, category: 'clothing', discount_price: 50) }
  let!(:expired_deal) { create(:deal, :expired) }

  describe 'GET #search' do
    context 'with valid parameters' do
      it 'returns successful response' do
        get :search
        expect(response).to have_http_status(:success)
      end

      it 'returns only not expired and available deals' do
        get :search
        expect(assigns(:deals)).to include(deal1, deal2)
        expect(assigns(:deals)).not_to include(expired_deal)
      end

      it 'includes distance calculation when lat and long provided' do
        get :search, params: { lat: 40, long: -74 }
        expect(response).to have_http_status(:success)
        expect(assigns(:deals).first).to respond_to(:distance)
      end
    end

    context 'with filtering parameters' do
      it 'filters by category' do
        get :search, params: { filters: { category: 'electronics' } }
        expect(assigns(:deals)).to include(deal1)
        expect(assigns(:deals)).not_to include(deal2)
      end

      it 'filters by subcategory' do
        get :search, params: { filters: { subcategory: 'phones' } }
        expect(assigns(:deals)).to include(deal1)
        expect(assigns(:deals)).not_to include(deal2)
      end

      it 'filters by price range' do
        get :search, params: { filters: { min_price: 60, max_price: 150 } }
        expect(assigns(:deals)).to include(deal1)
        expect(assigns(:deals)).not_to include(deal2)
      end

      it 'filters by featured' do
        get :search, params: { filters: { featured_deal: true } }
        expect(assigns(:deals)).to include(deal1)
        expect(assigns(:deals)).not_to include(deal2)
      end
    end

    context 'with sorting parameters' do
      it 'sorts by price ascending' do
        get :search, params: { sort: 'price', sort_direction: 'asc' }
        expect(response).to have_http_status(:success)
      end

      it 'sorts by discount descending' do
        get :search, params: { sort: 'discount', sort_direction: 'desc' }
        expect(response).to have_http_status(:success)
      end

      it 'sorts by distance when lat/long provided' do
        get :search, params: { sort: 'distance', sort_direction: 'asc', lat: 40, long: -74 }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when no deals found' do
      it 'returns not found error' do
        get :search, params: { filters: { category: 'inexistent category' } }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('No deals found')
      end
    end
  end

  describe 'parameter validation' do
    context 'with invalid sorting parameters' do
      it 'returns bad request for invalid sort option' do
        get :search, params: { sort: 'invalid_sort' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid sort option')
      end

      it 'returns bad request for missing sort direction' do
        get :search, params: { sort: 'price' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Sort direction must be provided')
      end

      it 'returns bad request for invalid sort direction' do
        get :search, params: { sort: 'price', sort_direction: 'invalid' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Invalid sort direction')
      end
    end

    context 'with invalid price parameters' do
      it 'returns bad request for non-numeric min_price' do
        get :search, params: { filters: { min_price: 'invalid' } }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('min_price / max_price must be numbers')
      end

      it 'returns bad request for non-numeric max_price' do
        get :search, params: { filters: { max_price: 'invalid' } }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('min_price / max_price must be numbers')
      end
    end

    context 'with distance sorting validation' do
      it 'returns bad request when sorting by distance without lat/long' do
        get :search, params: { sort: 'distance', sort_direction: 'asc' }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('lat and long must be provided for distance sorting')
      end

      it 'returns bad request when sorting by distance with only lat' do
        get :search, params: { sort: 'distance', sort_direction: 'asc', lat: 40 }
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('lat and long must be provided for distance sorting')
      end
    end

    context 'with blank parameters' do
      it 'removes blank parameters from params hash' do
        get :search, params: { filters: { category: '', min_price: '100', max_price: '' } }
        expect(controller.params.key?('category')).to be_falsey
        expect(controller.params.key?('max_price')).to be_falsey
        expect(controller.params['filters']['min_price']).to eq('100')
      end
    end
  end

  describe 'score calculation' do
    before do
      allow_any_instance_of(Deal).to receive(:calculate_score).and_return(0.8)
    end

    it 'calculates scores for all deals' do
      get :search
      assigns(:deals).each do |deal|
        expect(deal.instance_variable_get(:@score)).to be_present
      end
    end
  end
end
