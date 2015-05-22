set :stages, %w(production)     #various environments
load "deploy/assets"                    #precompile all the css, js and images... before deployment..
require 'bundler/capistrano'            # install all the new missing plugins...
require 'capistrano/ext/multistage'     # deploy on all the servers..
require 'rvm/capistrano'                # if you are using rvm on your server..
require './config/boot'
require 'whenever/capistrano'
require 'airbrake/capistrano'
require "delayed/recipes"

before "deploy:assets:precompile","deploy:config_symlink"

set :shared_children, shared_children + %w{public/uploads}


after "deploy:update", "deploy:cleanup" #clean up temp files etc.
after "deploy:update_code","deploy:migrate"
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

set :whenever_command, "bundle exec whenever"
set(:application) { "speedlancer" }
set :rvm_ruby_string, '2.2.0'             # ruby version you are using...
set :rvm_type, :system
set :whenever_environment, defer { stage }  # whenever gem for cron jobs...
set :whenever_identifier, defer { "#{application}_#{stage}" }
set :rails_env, "production"
set :delayed_job_args, "-n 2"
set :delayed_job_command, "bin/delayed_job"
server "104.130.228.46", :app, :web, :db, :primary => true
set (:deploy_to) { "/home/speedlancer/#{application}/#{stage}" }
set :user, 'speedlancer'
set :keep_releases, 10
# set :repository, "git@bitbucket.org:fizzysoftware/speedlancer.git"
set :repository, "git@bitbucket.org:speedlancerinc/speedlancer-repo.git"
set :use_sudo, false
set :scm, :git
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

namespace :deploy do

  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  desc 'Congifure symlinks like database.yml'
  task :config_symlink do
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    # put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after 'deploy:setup', 'deploy:setup_config'


  desc 'Make sure local git is in sync with remote.'
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts 'Run `git push` to sync changes.'
      exit
    end
  end
  before 'deploy', 'deploy:check_revision'

end

