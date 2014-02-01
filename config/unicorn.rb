require File.expand_path('../dyno',  __FILE__)

worker_processes WORKER_NUM

# https://devcenter.heroku.com/articles/rails-unicorn#timeouts
timeout Integer(ENV.fetch('UNICORN_TIMEOUT', 29))

preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to sent QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  defined? Redis and
    Redis.current and
    Redis.current.client.reconnect
  defined? Resque and
    Resque.redis = Redis.current
end
