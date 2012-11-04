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

    FACEBOOK_API = {:token => "296392173798471", :secret => "0af9a932b5aa9fd2829f4e4a241b982e"}
    VKONTAKTE_API = {:token => "3216855", :secret => "rAxzYrruwwN5pkjX1oRn"}

    LINKEDIN_API = {:token => "p57ga370woqx", :secret => "SlaQiUYqCQa0egtN"}
    TWITTER_API = {:token => "kLTBjcx6a2iYc89tuA5OPA", :secret => "2ghAfbabpKlhUHXhpuTh3SMnnRTYwdbrr4wqR9kafg"}
    GITHUB_API = {:token => "e46c3d4bed003f151f43", :secret => "64e21a543d8e6e5c5eb1762c04bea9cd3b5f08e5"}

    DROPBOX_API = {:token => "juyfneyjdfvjzmr", :secret => "eia2vk7wvno1bb0"}
    GOOGLE_API = {:token => "108633948545.apps.googleusercontent.com", :secret => "hE2BeYmHagFifYxaAnPsltxj"}



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
