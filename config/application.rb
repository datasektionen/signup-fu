require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

I18n.enforce_available_locales = false

module SignupFu
  class Application < Rails::Application
    config.encoding = "utf-8"

    config.filter_parameters += [:password, :password_confirmation]
    
    config.active_record.observers = :reply_observer
    
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :'sv-SE'
    
    config.action_view.javascript_expansions[:defaults] = %w(jquery jquery-ui rails application)

    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
