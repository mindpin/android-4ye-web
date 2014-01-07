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
  get "/knowledge_nets/:net_id/knowledge_nodes/:id/get_random_question" => "knowledge_nets#random_question"
  get "/knowledge_nets/:net_id/knowledge_nodes/:id/get_random_questions" => "knowledge_nets#random_questions"


  resources :knowledge_nets do
    resources :knowledge_nodes
  end
  
  resources :questions do
    collection do
      get :list
      get :net
      get :set
      get :node
    end
  end


end
