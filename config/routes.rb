Pan::Application.routes.draw do
  
  root :to => 'home#index'
  
  match '/welcome' => 'home#welcome'

  match 'beta' => 'enquiries#new', :id => 'feedback', :as => 'beta'
  match 'invite' => 'enquiries#new', :id => 'invite', :as => 'invite'
  
  match '/promoters/applications' => 'enquiries#index', :form_name => 'promoter', :as => 'promoter_enquiries'
  match '/beta/feedback' => 'enquiries#index', :form_name => 'feedback', :as => 'feedback_enquiries'

  resources :tour_dates do
    collection do
      get 'needs_approval'
      post 'approve_dates'
    end  
  end
  resources :performers, :except => [:show]
  resources :performers, :only => [:show] do
    resources :tours, :only => [:new, :index]    
    resources :reviews, :except => [:show, :delete]
    resources :messages, :only => [:new]
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


  
  resources :promoters, :except => [:show], :path => "organisations"
  resources :promoters, :only => [:show], :path => "organisations" do
    resources :users, :only => [:new, :create]
    resources :venues
    resources :messages, :only => [:new]
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
  
  devise_for :users
  devise_scope :user do
    get "login", :to => "devise/sessions#new", :as => "sign_in"
    get "new-password", :to => "devise/passwords#new", :as => "new_password"
    delete "logout", :to => "devise/sessions#destroy", :as => "sign_out"
    get "users/change_password", :to => "devise/registrations#edit", :as => "change_password"
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

  get 'shows', :to => 'shows#index'
  get 'shows/:id', :to => 'tours#show', :as => "show"

  match "shows/view/list" => "shows#set_view", :view => 'list', :as => 'set_list_view'
  match "shows/view/block" => "shows#set_view", :view => 'block', :as => 'set_block_view'

  get 'diary', :to => 'diary#index'
  
  get 'directory/search', :to => 'directory#search', :as => 'directory_search'
  get 'directory(/:letter)', :to => 'directory#directory', :as => 'directory'
  
  resources :groups do
    collection do
      get 'search'
    end
    member do
      resources :posts, :only => :show, :as => 'group_post'
    end
  end

  resources :messages, :only => [:create, :new]
  resources :collections, :except => :show
  
end
