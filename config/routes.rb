Android4yeWeb::Application.routes.draw do
  root :to => 'index#index'

    # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :sessions => :sessions
                     }
end


Android4yeWeb::Application.routes.draw do
  resources :users, :shallow => true do
    member do
      get :exp_info
    end
  end

  resources :questions
end
