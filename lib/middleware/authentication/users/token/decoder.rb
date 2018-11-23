require 'jwt'

module Authentication
  module Users
    module Token

      class Decoder
        include SemanticLogger::Loggable

        private_class_method :new

        EmptyJWT            = Class.new(Authentication::AuthError)
        CertificateNotFound = Class.new(Authentication::AuthError)
        JWTExpiredSignature = Class.new(Authentication::AuthError)

        # verify_expiration && verify_not_before are true by default
        VERIFICATION_OPTIONS = {
            algorithm:         'RS256',
            aud:               ENV!['FIREBASE_PROJECT_ID'],
            iss:               "https://securetoken.google.com/#{ENV!['FIREBASE_PROJECT_ID']}",

            verify_iat:        true,
            verify_aud:        true,
            verify_iss:        true,
            verify_expiration: true,
            verify_not_before: true
        }.freeze

        def initialize(logger: nil)
          @logger = logger if logger
        end

        def self.decode(jwt, **opts)
          new(**opts).decode(jwt)
        end

        # NOTE: We need to extract `kid` key from header JSON (hash) first,
        # to find certificate using it. In other words we cant just
        # call `JWT.decode`

        def decode(jwt)
          logger.info("Starting up, JWT: #{jwt}")

          if jwt.blank?
            logger.error("Blank JWT!")
            raise EmptyJWT, "Blank JWT received"
          end

          payload, _header = JWT.decode(jwt, cert_pub_key = nil, verify = true, VERIFICATION_OPTIONS) do |h, _p|
            logger.debug("Got jwt header: #{h}")

            cert_id = h['kid']
            logger.info("Cert ID (kid): (#{cert_id})")

            cert = get_cert_by_id(cert_id)
            logger.debug("Got cert contents:\n#{cert}")

            # Block should return public key
            OpenSSL::X509::Certificate.new(cert).public_key
          end

          logger.info("Decoded token payload: #{payload}")
          payload

            # We only want to wrap these exceptions, the rest should bubble up
        rescue ActiveRecord::RecordNotFound => e
          logger.error(e.message, e)
          raise CertificateNotFound, e

        rescue JWT::ExpiredSignature => e
          logger.error(e.message, e)
          raise JWTExpiredSignature, e
        end

        private

        def get_cert_by_id(cert_id)
          FirebaseCert.find_by!(kid: cert_id).content
        end
      end
    end
  end
end
