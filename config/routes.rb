TeamAura::Application.routes.draw do
  
  get "account/MyAccount"
  get "calendar" => 'calendar#index'
  resources :service_locations

  resources :addons

  resources :payments

  resources :appointments

  resources :services

  resources :user_services

  resources :location_hours

  resources :companies

  resources :locations

  resources :roles

  devise_for :users

  get 'company/:id/locations' => 'locations#index'
  root :to => 'default#index'

  get 'account'=>'account#index'
  get 'account/staff'=>'account#listStaff'
  get '/account/staff/edit/:id', :to => 'account#editStaff', :as => :account_staff_edit
  get '/account/staff/edit', :to =>'account#editStaff', :as => :account_staff_new
  post '/account/staff/create', :to =>'account#createStaff', :as => :account_staff_create
  post '/account/staff/update/:id', :to =>'account#updateStaff', :as => :account_staff_update
  get '/account/staff/delete/:id', :to =>'account#destroyStaff', :as => :account_staff_delete

  get '/account/locations', :to => 'locations#index',  :as => :list_account_locations_path
  get '/account/locations/new', :to => 'locations#new', :as => :new_account_location_path
  get '/account/locations/edit/:id', :to => 'locations#edit', :as => :edit_account_location_path
  post '/account/locations/create', :to =>'locations#create', :as => :create_account_locations_path
  post '/account/locations/update/:id', :to =>'locations#update', :as => :update_account_locations_path
  delete '/account/locations/delete/:id', :to =>'locations#destroy', :as => :delete_account_locations_path
  get '/locations/:id/hours/:month/:day/:year', :to => 'locations#hoursOpen', :as => :location_hours_path
  get '/locations/:id/times/:month/:day/:year', :to => 'locations#timesAvailable', :as => :location_times_path

  get '/account/services', :to => 'services#index',  :as => :list_account_services_path
  get '/account/services/new', :to => 'services#new', :as => :new_account_service_path
  get '/account/services/edit/:id', :to => 'services#edit', :as => :edit_account_service_path
  post '/account/services/create', :to =>'services#create', :as => :create_account_service_path
  post '/account/services/update/:id', :to =>'services#update', :as => :update_account_services_path
  delete '/account/services/delete/:id', :to =>'services#destroy', :as => :delete_account_services_path

  get '/account/appointments', :to => 'appointments#index',  :as => :list_account_appointments_path
  get '/account/appointments/new', :to => 'appointments#new',  :as => :new_account_appointment_path
  post '/account/appointments/create', :to => 'appointments#create',  :as => :create_account_appointment_path
  get '/account/appointments/edit/:id', :to => 'appointments#edit',  :as => :edit_account_appointment_path
  post '/account/appointments/update', :to => 'appointments#update',  :as => :update_account_appointment_path
  get '/account/appointments/approve/:id', :to => 'appointments#approve',  :as => :approve_account_appointment_path
  get '/account/appointments/cancel/:id', :to => 'appointments#cancel',  :as => :cancel_account_appointment_path
  get '/account/appointments/unapproved', :to => 'appointments#unapproved',  :as => :unapproved_account_appointment_path
  get '/account/appointments/approved', :to => 'appointments#approved',  :as => :approved_account_appointment_path
  get '/account/events', :to => 'appointments#events',  :as => :events_path

  get '/companies/:id', :to => 'companies#show', :as => :list_companies_locations_path
  get '/companies/:company_id/location/:location_id/book', :to =>'appointments#book', :as => :pass_companies_location_path
  get '/companies/:company_id/location/:location_id/booked', :to =>'appointments#booked', :as => :booked_account_appointment_path

  get '/payment/:payment_id', :to => 'payment#index', :as => :payment_to_show_appointment
  post '/payments/:id', :to => 'payment#thankyou', :as => :payment_to_thankyou
  get '/appointments/:appointment_id/payment', :to => 'payments#new', :as => :appointments_to_payment
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
