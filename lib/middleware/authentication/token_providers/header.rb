module Authentication
  module TokenProviders
    class Header
      class << self

        # TODO: Get back these useful messages
        # raise(AuthError, "Auth header found, but malformed: #{auth_header_value}")
        # raise(AuthError, "Auth header not found (expected one of: #{AUTHORIZATION_KEYS}")
        #
        def extract_jwt(env)
          auth_header_key = env[find_authorization_key(env)]
          BEARER_TOKEN_REGEX.match(auth_header_key)[1] if auth_header_key
        end

        private

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
        }x

        # Taken from Rack::Auth::AbstractRequest
        AUTHORIZATION_KEYS = %w[HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION]

        def find_authorization_key(env)
          AUTHORIZATION_KEYS.detect { |key| env.has_key?(key) }
        end
      end
    end
  end
end
