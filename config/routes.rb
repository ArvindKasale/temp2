CustomAction::Application.routes.draw do
 
  get "abc/index"

  post "form_builder/open_form"
  get "form_builder/index"
  get "form_builder/reorder_elements"
  get "form_builder/save_form"
  match "form_builder/delete_form/:id" => "form_builder#delete_form" 
  get "form_builder/get_forms"
  get "form_builder/new_form"
  get "form_builder/get_xml"
  get "form_builder/login"
  get "form_builder/lock_form"
  post "form_builder/login"
  post "form_builder/save_data"
  get "form_builder/new"
  post "form_builder/create"
  match "form_builder/delete_elements/:id" => "form_builder#delete_elements"
  match "form_builder/edit_elements/:id" => "form_builder#edit_elements"
  get "requests/savejson"
  get "requests/save_data"
  resources :requests
  get "videocon/index"

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'form_builder#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
