set :repository, "git@github.com:coolgandhi/magic.git"
set :deploy_to, "/var/www/travel"
set :scm_command, "/usr/local/git/bin/git"
set :user, "vagrant"
set :password, "vagrant"
set :scm_username, "coolgandhi"
set :local_scm_command, "git" 
set :rvm_ruby_string, 'ruby-1.9.3-p327' 
set :location, "192.168.33.10"
set :rails_env, "development"
set :branch, "master"


# for aws deploy
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/freeinstanceTrip.pem"]


# Automatically precompile assets
load "deploy/assets"
 
# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"
 
# RVM integration
require "rvm/capistrano"
#set :rvm_bin_path, "/home/ec2-user/.rvm/bin"
set :rvm_bin_path, "/home/vagrant/.rvm/bin"
$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
default_run_options[:pty] = true
# System-wide RVM installation
set :rvm_type, :system
# We use sudo (root) for system-wide RVM installation
set :rvm_install_with_sudo, true
set :rvm_install_pkgs, %w[libyaml openssl]
set :rvm_install_ruby_params, '--with-opt-dir=~/.rvm/usr'  # or for system installs:
# set :rvm_install_ruby_params, '--with-opt-dir=/usr/local/rvm/usr'
set :rvm_install_ruby, :install
before 'deploy:setup', 'rvm:install_pkgs'
before 'deploy:setup', 'rvm:install_ruby'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy', 'rvm:install_rvm'

# set :rvm_install_shell, :zsh
set :application, 'magicdelivery'
#ssh_options[:forward_agent] = true
set :use_sudo, false

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#set :deploy_subdir, "magicdelivery"
set :deploy_via, :copy
set :git_shallow_clone, 1
#set :user, "ec2-user"

#set :location, "ec2-50-112-211-203.us-west-2.compute.amazonaws.com"
#set :location, "192.168.33.10"
role :web, location                       # Your HTTP server, Apache/etc
role :app, location                          # This may be the same as your `Web` server
role :db,  location, :primary => true # This is where Rails migrations will run
role :db,  location
set :normalize_asset_timestamps, false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts


set :ec2onrails_config, {
	:mysql_root_password => "QAZwsx987"
}

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end
