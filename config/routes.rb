Android4yeWeb::Application.routes.draw do
  root :to => 'index#index'

    # devise
  devise_for :users, :path => 'account',
                     :controllers => {
                       :sessions => :sessions
                     }
end
