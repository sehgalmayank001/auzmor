class AccountsController < ApplicationController

  def index
    Rails.logger.info request.format
    render json: { data: 'hello' }, status: :ok
  end
end
