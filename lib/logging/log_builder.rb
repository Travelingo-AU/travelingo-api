require 'logger'
require 'fileutils'

class LogBuilder

  ENVIRONMENTS = %w[production development test]
  LOG_DIR      = ENV!['APP_ROOT'] + '/log'

  def self.build(log_tag: 'Not set', log_file: nil)
    log_target = if log_file
                   create_log_dir
                   "#{LOG_DIR}/#{log_file}"
                 elsif ENV!['RACK_ENV'] && ENVIRONMENTS.include?(ENV!['RACK_ENV'])
                   create_log_dir
                   "#{LOG_DIR}/#{ENV!['RACK_ENV']}.log"
                 else
                   $stdout # we don't need to create log dir here
                 end

    Logger.new(log_target).tap do |l|
      l.progname = log_tag

      l.formatter = proc do |severity, datetime, progname, msg|

        msg = case msg
              when ::String
                msg
              when ::Exception
                "#{ msg.message } (#{ msg.class })\n" <<
                  (msg.backtrace || []).join("\n")
              else
                msg.inspect
              end

        "%s, [%s PID: #%d] %5s -- [%s]: %s\n" % [
          severity[0..0], datetime.strftime('%Y-%m-%dT%H:%M:%S.%6N'),
          $$, severity, progname, msg]
      end
    end
  end

  def self.create_log_dir
    FileUtils.mkdir_p(LOG_DIR) unless Dir.exists?(LOG_DIR)
  end
end
