Rails.application.routes.draw do
  devise_for :users

  devise_scope :users do
    resources :notes
    get "notes/tag/:tag" => "notes#tagged", as: :notes_tagged
    post "search" => "notes#search", as: :note_search
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "notes#index"
end
