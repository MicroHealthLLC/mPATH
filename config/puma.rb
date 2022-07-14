max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5) 
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }

if Rails.env.production? 
  workers Integer(ENV['WEB_CONCURRENCY'] || 2) 
  threads min_threads_count, max_threads_count  
  nakayoshi_fork 
  wait_for_less_busy_worker 
  fork_worker  
  rails_port = ENV.fetch('PORT', 8443) 
  environment rails_env_prod
  pidfile ENV.fetch('PUMA_PIDFILE')  
  ssl_bind( 
    ENV.fetch('SSL_HOST'),
    rails_port, 
    key: ENV.fetch('SSL_KEY_FILE'), 
    cert: ENV.fetch('SSL_CERT_FILE'), 
    verify_mode: ENV.fetch('SSL_VERIFY_MODE')
  ) 
else 
  threads max_threads_count, max_threads_count
  port ENV.fetch("PORT") { 3000 }
  environment ENV.fetch('RAILS_ENV')
end  

plugin :tmp_restart 
preload_app! 