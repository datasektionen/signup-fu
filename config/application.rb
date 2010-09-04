require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module SignupFu
  class Application < Rails::Application
    config.encoding = "utf-8"

    config.filter_parameters += [:password, :password_confirmation]
    
    config.active_record.observers = :reply_observer
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :'sv-SE'
  end
end
