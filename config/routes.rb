Rails.application.routes.draw do
  get '/predictions/:date', to: 'predictions#index', as: :predictions
end
