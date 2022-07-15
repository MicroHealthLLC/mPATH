max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)

min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }

environment ENV.fetch('RAILS_ENV') { 'development' }

if ENV['RAILS_ENV'] == 'production'

workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads min_threads_count, max_threads_count

nakayoshi_fork

wait_for_less_busy_worker

fork_worker

pidfile ENV.fetch('PUMA_PIDFILE')

ssl_bind(

ENV.fetch('SSL_HOST'),

ENV.fetch('PUMA_PORT'),

key: ENV.fetch('SSL_KEY_FILE'),

cert: ENV.fetch('SSL_CERT_FILE'),

verify_mode: ENV.fetch('SSL_VERIFY_MODE')

)

else

threads max_threads_count, max_threads_count

port ENV.fetch("PUMA_PORT") { 3000 }

end

plugin :tmp_restart

preload_app!