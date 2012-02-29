Airbrake.configure do |config|
  config.api_key     = '005c740adf4109852f4cf3c3578d187f'
  config.host        = 'errbit.datasektionen.se'
  config.port        = 80
  config.secure      = config.port == 443
end

