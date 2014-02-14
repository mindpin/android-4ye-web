# worker 数量
worker_processes 3

project_4ye_path = File.expand_path("../../",__FILE__)
MINDPIN_MRS_DATA_PATH = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb MINDPIN_MRS_DATA_PATH`
PUBLISH_NAME          = `ruby #{project_4ye_path}/deploy/sh/parse_property.rb PUBLISH_NAME`
# 日志位置
stderr_path("/#{MINDPIN_MRS_DATA_PATH}/logs/unicorn-#{PUBLISH_NAME}-error.log")
stdout_path("/#{MINDPIN_MRS_DATA_PATH}/logs/unicorn-#{PUBLISH_NAME}.log")

# 加载 超时设置 监听
preload_app true
timeout 60
listen "/#{MINDPIN_MRS_DATA_PATH}/sockets/unicorn-#{PUBLISH_NAME}.sock", :backlog => 2048

pid_file_name = "/#{MINDPIN_MRS_DATA_PATH}/pids/unicorn-#{PUBLISH_NAME}.pid"
pid pid_file_name

# REE GC
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  old_pid = pid_file_name + '.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # ...
    end
  end
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end