Pan::Application.routes.draw do
  
  root :to => 'home#index'

  match 'beta' => 'enquiries#new', :id => 'feedback', :as => 'beta'
  match '/promoters/applications' => 'enquiries#index', :form_name => 'promoter', :as => 'promoter_enquiries'
  match '/beta/feedback' => 'enquiries#index', :form_name => 'feedback', :as => 'feedback_enquiries'

  resources :performers, :except => [:show]
  resources :performers, :only => [:show] do
    resources :tours, :only => [:new, :index]    
    resources :reviews, :except => [:show, :delete]
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'search'
      get 'genres', :action => 'index', :as => 'genres', :tag_context => 'genres'
      get 'art_forms', :action => 'index', :as => 'art_forms', :tag_context => 'art_forms'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'
      get 'rating'
    end
  end
  
  resources :tours, :except => [:new, :show]
  resources :tours, :only => [:show] do
    resources :reviews, :except => [:show, :delete]
    member do
      get 'bookings', :action => 'bookings'
    end
    collection do
      get 'rating'
      get ':tag_context/:tag', :action => 'index', :as => 'tag'
    end
  end
  
  resources :promoters, :except => [:show]
  resources :promoters, :only => [:show] do
    resources :users, :only => [:new, :create]
    resources :venues
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
      get 'regions(/:region_url)', :action => 'region', :as => 'region'
      get 'search'
      get 'individuals'
      get 'genres', :action => 'index', :as => 'genres', :tag_context => 'genres'
      get 'art_forms', :action => 'index', :as => 'art_forms', :tag_context => 'art_forms'
      get 'funders', :action => 'index', :as => 'funders', :tag_context => 'funders'
      get 'scale_of_work', :action => 'index', :as => 'scale_of_work', :tag_context => 'work_scales'
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
