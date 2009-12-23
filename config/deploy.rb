set :application, "signup-fu"
set :repository,  "git@dev.signup-fu.com:signup-fu.git"
set :deploy_to, "/srv/rails/#{application}"

set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

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
  after "deploy:symlink", "deploy:copy_config"
end

namespace :delayed_job do
  desc "Start delayed_job process"
  task :start, :roles => :app do
    run "export RAILS_ENV=production; cd #{current_path}; script/delayed_job start"
  end
 
  desc "Stop delayed_job process"
  task :stop, :roles => :app do
    run "export RAILS_ENV=production; cd #{current_path}; script/delayed_job stop"
  end
 
  desc "Restart delayed_job process"
  task :restart, :roles => :app do
    run "export RAILS_ENV=production; cd #{current_path}; script/delayed_job restart"
  end
end
after "deploy:start", "delayed_job:start"
after "deploy:stop", "delayed_job:stop"
after "deploy:restart", "delayed_job:restart"

desc "remote console" 
task :console, :roles => :app do
  input = ''
  run "cd #{current_path} && ./script/console #{ENV['RAILS_ENV']}" do |channel, stream, data|
    next if data.chomp == input.chomp || data.chomp == ''
    print data
    channel.send_data(input = $stdin.gets) if data =~ /^(>|\?)>/
  end
end
