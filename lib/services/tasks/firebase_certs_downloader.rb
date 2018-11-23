require 'httparty'

module Tasks

  class FirebaseCertsDownloader

    CERTS_URI = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'

    # NOTE: Add customization if needed later
    def initialize(logger: nil)
      @logger = logger || default_logger
    end

    attr_reader :logger

    def run
      log("started")
      json = requrest_current_firebase_certs

      unless json
        log("FAILED TO DOWNLOAD JSON")
        return
      end

      save_certs(json)

      log("done")
    end

    private

    def requrest_current_firebase_certs
      log("requesting new certs JSON...")

      response = HTTParty.get(CERTS_URI)
      return unless response.ok?

      log("response OK, saving")
      response.body
    end

    def save_certs(json)
      log("saving new certs")

      certs_hash = JSON.parse(json)
      certs_hash.each do |kid, cert|
        if FirebaseCert.where(kid: kid).exists?
          log("cert with kid #{kid} already exists in DB, skipping")
          next
        end

        log("cert with kid #{kid} is new, creating new record")
        FirebaseCert.create!(kid: kid, content: normalize_cert(cert))
      end
    end

    def normalize_cert(cert)
      cert.gsub('\n', "\n")
    end

    # By default log to stdout
    def default_logger
      Logger.new(STDOUT)
    end

    def self.run(*args)
      new(*args).run
    end

    def log(msg)
      logger.info("[FirebaseCertsDownloader] #{msg}")
    end
  end
end
