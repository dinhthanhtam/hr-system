set :rails_env, 'staging'
set :deploy_env, 'staging'

role :web, 'localhost'
role :app, 'localhost'
role :db, 'localhost', :primary => true

