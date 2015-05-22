require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Speedlancer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    app_keys = File.join(Rails.root, 'config', 'app_keys.yml')
    CONFIG = HashWithIndifferentAccess.new(YAML::load(IO.read(app_keys)))[Rails.env]
    CONFIG.each do |k,v|
      ENV[k.upcase] ||= v
    end

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.test_framework false
      g.scaffold_controller "scaffold_controller"
      g.stylesheets false
      g.javascripts false
      g.helper false
      g.assets false
    end

  end
end
