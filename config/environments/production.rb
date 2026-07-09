require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored for rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry since they are all digest stamped.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files on the local file system.
  config.active_storage.service = :local

  # Assume all access is happening through a SSL-terminating reverse proxy.
  # config.assume_ssl = true

  # Force all access over SSL.
  # config.force_ssl = true

  # Log to STDOUT.
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)

  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging logs.
  config.silence_healthcheck_path = "/up"

  # Don't log deprecations.
  config.active_support.report_deprecations = false

  # Solid Cache
  config.cache_store = :solid_cache_store

  # Solid Queue
  config.active_job.queue_adapter = :solid_queue
  config.solid_queue.connects_to = { database: { writing: :queue } }

  # Mailer configuration
  config.action_mailer.perform_deliveries = false


  # Internationalization fallbacks
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Host authorization.
  # config.hosts = [
  #   "example.com",
  # ]
end
