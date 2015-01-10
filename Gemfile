source 'http://rubygems.org'

gem 'rails', '~> 3.0.0'
gem 'mysql2', '~> 0.2.11'

gem "liquid"
gem "haml"
gem "state_machine"
gem 'RedCloth'
gem 'simple_form'
gem 'compass'
gem 'devise'
gem 'cancan'
gem 'delayed_job'
gem 'jquery-rails'
gem 'airbrake'

group :development, :test do
  gem 'rspec-rails',"~> 2.14"
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'capybara'
  gem 'database_cleaner', '~> 0.7.0'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'libnotify'
  gem 'pry-rails'
end

group :test do
  gem 'cucumber-rails', require: false
end

group :deploy do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
end

group :production do
  gem 'unicorn'
end
