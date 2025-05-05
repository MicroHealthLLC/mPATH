require 'yaml'

# Load optional YAML config
if File.exist?('./puma_config.yml')
  yaml_data = YAML.load_file('./puma_config.yml')
  yaml_data.each do |key, value|
    ENV[key] = value if value
  end
end

rails_env = ENV.fetch('RAILS_ENV')
puma_port = Integer(ENV.fetch('PUMA_PORT'))

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)

workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
threads min_threads_count, max_threads_count

environment rails_env

# Optional logging for debug
puts "[Puma] ENV PUMA_PORT=#{puma_port}"
puts "[Puma] ENV RAILS_ENV=#{rails_env}"

if rails_env == 'production'
  pidfile ENV.fetch('PUMA_PIDFILE')

  # Commented out SSL bind since Nginx handles TLS
  # begin
  #   ssl_bind(
  #     ENV.fetch('PUMA_SSL_HOST'),
  #     puma_port,
  #     key: ENV.fetch('PUMA_SSL_KEY_FILE'),
  #     cert: ENV.fetch('PUMA_SSL_CERT_FILE'),
  #     verify_mode: ENV.fetch('PUMA_SSL_VERIFY_MODE')
  #   )
  #   puts "[Puma] SSL bind successful on #{ENV['PUMA_SSL_HOST']}:#{puma_port}"
  # rescue KeyError => e
  #   warn "[Puma] Missing SSL ENV variable: #{e.message}"
  #   exit 1
  # end

  port puma_port
else
  port puma_port
end

plugin :tmp_restart
