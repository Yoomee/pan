Pan::Application.routes.draw do
  
  root :to => 'home#index'

  resources :performers, :except => [:show]
  resources :performers, :only => [:show] do
    resources :tours, :only => [:new, :index]    
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'
    end
  end
  
  resources :tours, :except => [:new]
  resources :tours, :only => [] do
    member do
      get 'bookings', :action => 'bookings'
    end
    collection do
      get ':tag_context/:tag', :action => 'index', :as => 'tag'
    end
  end
  
  resources :promoters, :except => [:show]
  resources :promoters, :only => [:show] do
    resources :users, :only => [:new, :create]
    resources :venues
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get 'individuals'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'      
    end
  end
  
  resources :venues, :except => :new do
    member do
      get 'location', :as => 'edit_location'
      get 'bookings', :action => 'bookings'
    end
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get 'latest' 
    end
  end
  
  resources :users
  resources :users, :only => [] do
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'      
    end
    member do
      put 'update_role/:role', :action => 'update_role', :as => 'update_role'
    end
  end
  
  resources :tags, :only => [:index]
  
  match 'community' => 'posts#index'
  
  resources :registrations, :only => [:new, :create]

  resources :resources do
    collection do
      get 'search'
    end
    member do
      get 'download'
    end
  end
  
end
