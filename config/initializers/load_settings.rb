config_file = "#{Rails.root}/config/settings.yml"
 
begin
  APP_CONFIG = HashWithIndifferentAccess.new(YAML.load_file(config_file)[RAILS_ENV])
rescue Errno::ENOENT => e
  $stderr.puts "Unable to find configuration file #{config_file}"
  exit
end
 
if APP_CONFIG.nil?
  puts "Unable to find #{RAILS_ENV} environment in #{config_file}"
  exit
end

