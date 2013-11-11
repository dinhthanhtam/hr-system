APP_NAME = 'framgia_hr'
rails_env = ENV['RAILS_ENV'] || 'staging'
worker_processes 4
working_directory "/usr/local/rails_apps/#{APP_NAME}/current"

listen "/tmp/unicorn_app.sock", :backlog => 2048
listen 5000, :tcp_nopush => true

timeout 30

pid "/tmp/unicorn_app.pid"
preload_app true
stderr_path "/usr/local/rails_apps/#{APP_NAME}/shared/log/#{APP_NAME}_app.log"
stdout_path "/usr/local/rails_apps/#{APP_NAME}/shared/log/#{APP_NAME}_app.log"

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "/usr/local/rails_apps/#{APP_NAME}/current/Gemfile"
end

before_fork do |server, worker|
  
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
