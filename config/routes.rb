GodaiProject::Application.routes.draw do

  root :to => 'home#index'

  # Unfortunately, the default resourceful routes don't quite work for file manager
  # operations
  match 'files/get' => 'files#get', :as => 'get_file'
  match 'files/' => 'files#index', :as => 'files'
  match 'files/delete' => 'files#destroy', :as => 'delete_file'
  match 'files/rmdir' => 'files#delete_directory', :as => 'delete_directory'
  match 'files/mkdir' => 'files#new_directory', :as => 'new_directory'
  match 'files/list' => 'files#list', :as => 'file_list'
  resources :user_sessions

  match 'login' => 'user_sessions#new', :as => 'login'
  match 'logout' => 'user_sessions#destroy', :as => 'logout'

end
