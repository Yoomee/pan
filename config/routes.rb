Pan::Application.routes.draw do
  
  root :to => 'home#index'
  match 'performers/directory(/:letter)' => 'performers#directory', :as => 'directory_performers' # Must come before resources :performers
  resources :performers do
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
