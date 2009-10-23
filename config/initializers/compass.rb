require 'compass'
if ENV['HEROKU_SLUG'].nil?
  # If you have any compass plugins, require them here.
  Compass.configuration.parse(File.join(RAILS_ROOT, "config", "compass.config"))
  Compass.configuration.environment = RAILS_ENV.to_sym
  Compass.configure_sass_plugin!
else
  Sass::Plugin.options[:never_update] = true
end
