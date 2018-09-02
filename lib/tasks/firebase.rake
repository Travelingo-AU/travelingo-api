require 'pp'

namespace :firebase do
  desc "Decode Firebase token"
  task :decode_jwt, [:token] => :environment do |_task, args|
    token = args[:token]

    fail "Usage: rake fb_jwt_decode[<jwt>]" unless token

    payload, header = Authentication::Users::Token.decode(token.strip, verify = false)

    puts "\nHeader:\n\n"
    pp header
    puts "\nPayload:\n\n"
    pp payload
    puts
  end

  # NOTE: Don't forget to update config/schedule.rb if changing name
  # Also, use cron output redirection for logging

  desc "Download current Firebase certs"
  task get_current_certs: :environment do
    Tasks::FirebaseCertsDownloader.run
  end
end
