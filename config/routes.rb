Rails.application.routes.draw do

  resources :comments
  resources :projects, :only => [:new, :create, :destroy]
  resources :contents
  devise_for :users, controllers:{omniauth_callbacks:"omniauth_callbacks"}
  resources :users
  resources :content_attachments, :only => [:new, :create, :destroy]

  get 'content_attachment/new/:id', to: 'content_attachments#new', :as => :newContentAttachment

  resources :projects do
    collection {post :sort}
  end

  get 'welcome/index'
  get 'welcome/tweet'
  get 'contents/timeline'
  get 'contents/create_tweet'

  get '/consulting', to: "users#show", as:'consulting'

  post 'emailapi/subscribe' => 'emailapi#subscribe'

  get '/schedule', to: 'users#schedule', as:'schedule'
  # get 'content_attachments/new', to: 'content_attachments#new', :as => :newContentAttachment

  get 'tags/:tag', to: 'users#show', as: :tag
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Subdomain Support: http://railscasts.com/episodes/123-subdomains-revised?autoplay=true
  get '', to: 'users#show', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }
  get '/settings', to: 'users#edit', as: 'settings'

  # get '/settings', to: 'users#edit', as: 'settings', constraints: lambda { |r| r.subdomain.present? && r.subdomain != 'www' }

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  root :to => "users#show", :id => User.find_by_subdomain("wesadvance").id


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
