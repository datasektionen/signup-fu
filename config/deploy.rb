set :application, "signup-fu"
set :repository,  "git@dev.signup-fu.com:signup-fu.git"
set :deploy_to, "/srv/rails/#{application}"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "signup-fu.com"                          # Your HTTP server, Apache/etc
role :app, "signup-fu.com"                          # This may be the same as your `Web` server
role :db,  "signup-fu.com", :primary => true # This is where Rails migrations will run

set :user, 'signupfu'
set :use_sudo, false

ssh_options[:keys] = %w(/Users/spatrik/.ssh/id_dsa)  

default_run_options[:pty] = true
# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  #task :start { puts "eh no" }
  #task :stop { puts "eh no" }
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  task :config_setup do
    run "mkdir #{shared_path}/config"
  end
  after :"deploy:setup", :config_setup
  
  task :copy_config do
    run "cp #{shared_path}/config/* #{release_path}/config"
  end
  after :"deploy:symlink", :"deploy:copy_config"
end
