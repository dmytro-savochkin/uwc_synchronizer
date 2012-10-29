require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Uwcplus
  class Application < Rails::Application

    FACEBOOK_API = {:token => "215305611933443", :secret => "0e6c8039f9fdccad79f8cd4872af052f"}
    LINKEDIN_API = {:token => "if1e5eo991ru", :secret => "eZKIBNnmoDhMUTXt"}
    VKONTAKTE_API = {:token => "3175222", :secret => "8XHtp6aIrcdlEEGbxzdL"}
    TWITTER_API = {:token => "NEyPya21yA9Cj36YAlXNg", :secret => "Lt0ciRDxMFqnqEgm4bH7P8yXdU7awF8z5OU1uVvAGl4"}
    GITHUB_API = {:token => "469b0707e99cb1be93cd", :secret => "c8d17a473d42d1c438235179fb5c77869d00322c"}

    DROPBOX_API = {:token => "ou771rjh0ytd16h", :secret => "9apfd0pe1ol9zgk"}
    GOOGLE_API = {:token => "227399176915.apps.googleusercontent.com", :secret => "ypw_Fx0x8DTFVcPPYyEBz0X-"}



    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    #config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end
