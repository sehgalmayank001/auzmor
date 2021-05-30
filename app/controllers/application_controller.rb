class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authenticate!

  def authenticate!
    if account = authenticate_with_http_basic { |usnm, pswd| Account.find_by(auth_id: pswd, username: usnm) }
      @current_account = account
    else
      render json: { data: 'HTTP Basic: Access denied.' }, status: :forbidden
    end
  end

  def json_response(data, status = :ok)
    render json: data, status: status
  end

  # rescue_from Exception do |e|
  #   json_response({ errors: { message: 'something went wrong' } }, :not_found)
  # end
end
