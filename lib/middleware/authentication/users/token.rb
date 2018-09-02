require 'jwt'

module Authentication
  module Users
    class Token
      extend CommonLogging

      class << self

        # NOTE: We need to extract `kid` key from header JSON (hash) first,
        # to find certificate using it. In other words we cant just
        # call `JWT.decode`

        def decode(jwt, verify = true)
          logger.info("[JwtDecoder] Starting up, JWT: #{jwt}")

          raise StandardError, "Can't decode JWT. Reason: blank" if jwt.blank?

          header = extract_and_parse_jwt_header(jwt)

          logger.info("[JwtDecoder] got jwt header: #{header}")

          cert_id = header['kid']
          cert    = get_cert_by_id(cert_id)

          logger.info("[JwtDecoder] got cert by ID (#{cert_id}):\n#{cert}")
          cert = OpenSSL::X509::Certificate.new(cert)

          # agrs: jwt, key, verify the signature of this token
          payload, _header = JWT.decode(jwt, cert.public_key, verify, VERIFICATION_OPTIONS)
          payload
        end

        private

        # verify_expiration && verify_not_before are true by default
        VERIFICATION_OPTIONS = {
          algorithm:  'RS256',
          verify_iat: true,
          aud:        ENV!['FIREBASE_PROJECT_ID'],
          verify_aud: true,
          iss:        "https://securetoken.google.com/#{ENV!['FIREBASE_PROJECT_ID']}",
          verify_iss: true
        }

        def get_cert_by_id(cert_id)
          FirebaseCert.find_by!(kid: cert_id).content
        end

        def extract_and_parse_jwt_header(jwt)
          header = jwt.split('.').first
          # Using this tricky b64-decode method
          header = JWT::Decode.base64url_decode(header)
          JSON.parse(header)
        end
      end
    end
  end
end
