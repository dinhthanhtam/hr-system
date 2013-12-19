HrSystem::Application.routes.draw do
  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }

  resources :reports do
    get :summary, on: :collection
  end
  resources :report_categories
  
  resources :stickies
  resources :users do
    get :get_team, on: :collection
    get :get_all_user, on: :collection
    get :profile, on: :member
    patch :update_profile, on: :member
    post :update_profile, on: :member
    post :update_user_role, on: :collection
    get :organizations, on: :collection
  end
  
  resources :groups do
    resources :teams
  end

  resources :project_users do
    resources :project_user_roles
  end

  resources :projects do
    resources :costs
    resources :project_users do
      get :member_list, on: :collection
      post :update_roles, on: :collection
    end
    get :gantt, on: :collection
    get :gantt_list, on: :collection
    get :export_excel, on: :collection
    post :assign_members, on: :collection
  end
  resources :project_users

  resources :payslips do
    get :download, on: :member
    post :send_payslip, on: :collection
  end

  resources :feedbacks do
    get :fixed, on: :member
  end

  resources :checkpoint_questions
  resources :checkpoint_periods


  resources :checkpoints do
    get :review, on: :member
  end

  root to: "users#index"
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
