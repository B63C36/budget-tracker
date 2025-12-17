Rails.application.routes.draw do
  resources :expenses, except: [:new, :edit]
  #root 'expenses#index'
  get 'expenses/summary', to: 'expenses#summary'
end