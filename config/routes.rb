Pan::Application.routes.draw do
  
  root :to => 'home#index'
  resources :performers do
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search' 
    end
    resources :tours, :only => [:new, :index]
  end
  resources :tours, :except => [:new]
  resources :promoters do
    resources :users, :only => [:new, :create]
    resources :venues
  end
  resources :venues, :except => :new
  resources :tags, :only => []
  match 'community' => 'posts#index'

  resources :resources do
    collection do
      get 'search'
    end
    member do
      get 'download'
    end
  end
  
end
