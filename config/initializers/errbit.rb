Airbrake.configure do |config|
  config.api_key = 'f2ba9c3b1221f390036f916eb1f878ac'
  config.host    = 'errors.fizzysoftware.com'
  config.port    = 80
  config.secure  = config.port == 443
end
