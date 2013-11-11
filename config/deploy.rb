require 'capistrano/ext/multistage'
require 'bundler/capistrano'

# Application name
set :application, "framgia_hr"

# Repository
set :repository,  "https://github.com/dainghiavotinh/framgia_hr.git"
set :scm, :git

# RVM
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p448'
set :rvm_type, :system

# Deploy user
set :user, 'nghialv'
set :use_sudo, false
set :default_run_options, :pty => true

# Directories
set :deploy_to, "/usr/local/rails_apps/#{application}"

# Set tag, branch or revision
set :current_rev, `git show --format='%H' -s`.chomp
set :branch do
  default_tag = current_rev
  tag = ENV["DEPLOY_TARGET"] || Capistrano::CLI.ui.ask("Tag to deploy : [#{default_tag}]")
  tag = default_tag if tag.empty?
  tag 
end

# for Unicorn
namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "kill -USR2 `cat /tmp/unicorn_app.pid`"
  end
  task :reload, :roles => :web, :except => { :no_release => true } do
    run "kill -HUP `cat /tmp/unicorn_app.pid`"
  end
  task :delete_old do
    set :keep_releases, 2
  end
end

desc "after finish deploy"
task :symlink, :roles => :app do
  run "ln -s #{current_path}/config/databases/#{rails_env}.yml #{current_path}/config/database.yml"
end

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
