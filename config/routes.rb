Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  devise_for :users

  devise_scope :users do
    resources :notes, concerns: :paginatable
    get "notes/tag/:tag(/page/:page)" => "notes#tagged", as: :notes_tagged
    post "search" => "notes#search", as: :note_search
    get "tags/cloud" => "notes#tag_cloud", as: :tag_cloud
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "notes#index"
end
