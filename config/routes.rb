Pan::Application.routes.draw do
  
  root :to => 'home#index'
  resources :performers do
    collection do
      get 'directory(/:letter)', :action => 'directory', :as => 'directory'
    end
    resources :tours, :only => [:new]
  end
  resources :tours, :except => [:new]
  resources :promoters do
    resources :users, :only => [:new, :create]
    resources :venues
  end
  resources :venues, :except => :new
  resources :tags, :only => [] do
    collection do 
      get 'autocomplete_genre_name'
      get 'autocomplete_art_form_name'
      get 'autocomplete_funder_name'
    end
  end
  match 'community' => 'posts#index'
  resources :resources, :only => [:index]
  
end
