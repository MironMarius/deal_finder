module ErrorMessages
  def err_not_found
    render json: { error: "No deals found" }, status: :not_found
  end

  def err_bad_request(message)
    render json: { error: message }, status: :bad_request
  end
end
