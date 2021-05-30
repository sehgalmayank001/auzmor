Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resource :inbound, only: [], defaults: { format: :json } do
    post :sms
  end

  resource :outbound, only: [], defaults: { format: :json } do
    post :sms
  end
end
