# frozen_string_literal: true
require "yaml"

# Load optional YAML config
if File.exist?("./puma_config.yml")
  yaml_data = YAML.safe_load(File.read("./puma_config.yml")) || {}
  yaml_data.each { |k, v| ENV[k.to_s] = v.to_s if v }
end

rails_env = ENV.fetch("RAILS_ENV", "production")
# Support either PUMA_PORT or PORT, fallback to 8443
puma_port = Integer(ENV["PUMA_PORT"] || ENV["PORT"] || 8443)

max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS", max_threads_count))

workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))
threads min_threads_count, max_threads_count

environment rails_env


STDOUT.puts "[Puma] ENV PORT=#{ENV['PORT']}"
STDOUT.puts "[Puma] ENV PUMA_PORT=#{ENV['PUMA_PORT']}"
STDOUT.puts "[Puma] RAILS_ENV=#{rails_env}"

# PID file
pidfile ENV.fetch("PUMA_PIDFILE", File.join(Dir.pwd, "tmp/pids/server.pid"))

# We’re terminating TLS at ALB
bind "tcp://0.0.0.0:#{puma_port}"

plugin :tmp_restart
