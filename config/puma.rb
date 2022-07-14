
rails_env_prod = ENV.fetch('RAILS_ENV', 'production') 

rails_env_dev = ENV.fetch('RAILS_ENV', 'development') 

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5) 

min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count } 


if rails_env_prod == 'production' 

workers Integer(ENV['WEB_CONCURRENCY'] || 2) 

threads min_threads_count, max_threads_count  

nakayoshi_fork 

wait_for_less_busy_worker 

fork_worker  

rails_port = ENV.fetch('PORT', 8443) 

environment rails_env_prod

pidfile ENV.fetch('PIDFILE', '/home/puma/server.pid')  

  ssl_bind( 

    '0.0.0.0',

    rails_port, 

    key: ENV.fetch('SSL_KEY_FILE', '/etc/pki/tls/private/microhealthllc.com.key'), 

    cert: ENV.fetch('SSL_CERT_FILE', '/etc/pki/tls/certs/microhealthllc.com.crt'), 

    verify_mode: 'none' 

  ) 

else 
    threads max_threads_count, max_threads_count
    port ENV.fetch("PORT") { 3000 }
    environment rails_env_dev
end  


plugin :tmp_restart 


preload_app! 