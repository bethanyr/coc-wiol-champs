Seis2::Application.routes.draw do

  resources :teams, only: [:index, :show] do
    collection { post :import}
  end

  resources :runners, only: :index do
    collection { post :import}
  end

  
  get "individual_day1" => "individual#day1"
  get "individual_day2" => "individual#day2"
  get "individual_total" => "individual#index"

  get "team_day1" => "teams2#day1"
  get "team_day2" => "teams2#day2"
  get "team_total" => "teams2#index"
  

  get "awt" => "awt#index"
  root :to => 'home#index'

  match "*path", to: "home#index", via: :all

end
