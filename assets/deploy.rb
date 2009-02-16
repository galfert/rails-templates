#############################################################
#	Application
#############################################################
set :application, "vonhoegen"
set :deploy_to, "/var/www/#{application}"

#############################################################
#	Settings
#############################################################
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production" 

#############################################################
#	Servers
#############################################################
set :user, "deploy"
set :domain, "YOUR_DOMAIN"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################
set :scm, :git
set :branch, "master"
set :repository, "git@YOUR_SERVER_HOSTNAME:YOUR_REPOSITORY.git"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

#############################################################
#	Deployment
#############################################################
namespace :deploy do
  # Create symlinks for config files  
  task :after_symlink do
    %w(database.yml).each do |c|
      run "ln -nsf #{shared_path}/system/config/#{c} #{current_path}/config/#{c}"
    end
  end
    
  # Restart passenger on deploy
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
