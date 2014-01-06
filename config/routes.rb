Android4yeWeb::Application.routes.draw do
  root :to => 'index#index'

    # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :sessions => :sessions
                     }
end


Android4yeWeb::Application.routes.draw do
  resources :knowledge_nets, :shallow => true do
    member do
      get :exp_info
    end
  end

  resources :questions do
    collection do
      get :list
      get :net
      get :set
      get :node
      get :random
      get :randoms
    end
  end
end
