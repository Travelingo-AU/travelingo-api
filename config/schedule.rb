set :chronic_options, hours24: true
set :output, File.expand_path("#{__dir__}/../log/cron_tasks.log")

every 1.hour do
  rake "firebase:get_current_certs"
end
