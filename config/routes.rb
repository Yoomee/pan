Pan::Application.routes.draw do
  
  root :to => 'home#index'

  resources :performers
  resources :performers, :only => [] do
    resources :tours, :only => [:new, :index]    
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'
    end
  end
  
  resources :tours, :except => [:new] do
    member do
      get 'bookings', :action => 'bookings'
    end
  end
  
  resources :promoters
  resources :promoters, :only => [] do
    resources :users, :only => [:new, :create]
    resources :venues
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search' 
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
  
  resources :users, :only => [:index] do
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
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
