module Authentication
  module TokenProviders
    class Header

      include SemanticLogger::Loggable

      private_class_method :new

      MalformedAuthHeaderValue = Class.new(Authentication::AuthError)

      def self.find_jwt(rack_env, **opts)
        new(**opts).find_jwt(rack_env)
      end

      def initialize(logger: nil)
        @logger = logger if logger
      end

      # Taken from https://github.com/eigenbart/rack-jwt/blob/master/lib/rack/jwt/auth.rb
      # but require third part (sign info) to exists too

      # The last segment gets dropped for 'none' algorithm since there is no
      # signature so both of these patterns are valid. All character chunks
      # are base64url format and periods.
      #   Bearer abc123.abc123.abc123
      #   Bearer abc123.abc123.
      BEARER_TOKEN_REGEX = %r{
          ^Bearer\s{1}(       # starts with Bearer and a single space
          [a-zA-Z0-9\-\_]+\.  # 1 or more chars followed by a single period
          [a-zA-Z0-9\-\_]+\.  # 1 or more chars followed by a single period
          [a-zA-Z0-9\-\_]+    # 1 or more chars, no trailing chars
          )$
        }x.freeze

      # Taken from Rack::Auth::AbstractRequest
      AUTHORIZATION_KEYS = %w[HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION].freeze

      # If header not found - silently ignore (return nil) - this case is used
      # by #valid? in Warden strategy
      def find_jwt(rack_env)
        auth_header_key = find_authorization_key(rack_env)
        return unless auth_header_key

        logger.debug("Found auth header key", auth_header_key: auth_header_key)

        auth_header_value = rack_env[auth_header_key]
        match_and_extract_jwt(auth_header_value)
      end

      def match_and_extract_jwt(auth_header_value)
        matches = BEARER_TOKEN_REGEX.match(auth_header_value)

        error_msg = "Authentication header present, but malformed"

        unless matches
          logger.error(error_msg, header_value: auth_header_value)
          raise MalformedAuthHeaderValue, error_msg
        end

        matches[1]
      end

      def find_authorization_key(rack_env)
        AUTHORIZATION_KEYS.detect { |key| rack_env.has_key?(key) }
      end
    end
  end
end
