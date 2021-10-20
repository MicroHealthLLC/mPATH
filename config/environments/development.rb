Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Do not dump schema after migrations.
  # config.active_record.dump_schema_after_migration = false
  if File.exist?("#{Rails.root}/config/emails.yml")
    emails = YAML::load(File.open("#{Rails.root}/config/emails.yml"))
    if emails['email_delivery']
      config.action_mailer.delivery_method = emails['email_delivery']['delivery_method'] if emails['email_delivery']['delivery_method']
      config.action_mailer.smtp_settings = emails['email_delivery']['smtp_settings'].symbolize_keys if emails['email_delivery']['smtp_settings']
    end
    config.action_mailer.default_url_options = emails['action_mailer_config'].symbolize_keys if emails['action_mailer_config']
  end

  # This will generate copy of log files if log reaches to 500 kb. 2 meaning 1 copy file and 1 current log file.
  config.logger = ActiveSupport::Logger.new(config.paths['log'].first, 2, 500.kilobytes)

  # config.after_initialize do

  #   Bullet.enable = true
  #   # Bullet.sentry = true
  #   # Bullet.alert = true
  #   Bullet.bullet_logger = true
  #   # Bullet.console = true
  #   # Bullet.growl = true
  #   # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  #   #                 :password => 'bullets_password_for_jabber',
  #   #                 :receiver => 'your_account@jabber.org',
  #   #                 :show_online_status => true }
  #   # Bullet.rails_logger = true
  #   # Bullet.honeybadger = true
  #   # Bullet.bugsnag = true
  #   # Bullet.airbrake = true
  #   # Bullet.rollbar = true
  #   Bullet.add_footer = true
  #   Bullet.skip_html_injection = false
  #   # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
  #   # Bullet.stacktrace_excludes = [ 'their_gem', 'their_middleware', ['my_file.rb', 'my_method'], ['my_file.rb', 16..20] ]
  #   # Bullet.slack = { webhook_url: 'http://some.slack.url', channel: '#default', username: 'notifier' }

  # end

  config.action_cable.url = "ws://localhost:3000/cable"
  config.action_cable.disable_request_forgery_protection = true

end
