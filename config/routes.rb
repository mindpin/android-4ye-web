Android4yeWeb::Application.routes.draw do
  root :to => 'index#index'
    # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :sessions => :"sessions"
                     }
end

Android4yeWeb::Application.routes.draw do
  namespace :api do

    resources :knowledge_nets do
      member do
        get :exp_info
      end
      collection do
        get :list
      end

      resources :knowledge_sets
      resources :knowledge_nodes do
        member do
          get :test_success
        end
      end
      
    end
    
    get "/knowledge_nets/:net_id/knowledge_nodes/:id/get_random_question" => "knowledge_nets#random_question"
    get "/knowledge_nets/:net_id/knowledge_nodes/:id/get_random_questions" => "knowledge_nets#random_questions"
    get "/user/profile" => 'index#user_profile'
                       
  end


  
  resources :questions do
    collection do
      get :list
      get :net
      get :set
      get :node
    end
  end

  resources :image_datas
end
