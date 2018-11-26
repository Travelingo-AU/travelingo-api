module Authentication
  module Users

    # HOOKS LIST
    # https://github.com/wardencommunity/warden/wiki/Callbacks
    # after_set_user
    # after_authentication
    # after_fetch
    # before_failure
    # after_failed_fetch
    # before_logout
    # on_request

    class JwtHeaderStrategy < Warden::Strategies::Base
      include SemanticLogger::Loggable

      def valid?
        scope == :api_user && bearer_header_found?
      end

      def authenticate!
        logger.info("Authenticating #{scope}")

        firebase_user_uid = jwt_payload['sub']
        user              = find_user(firebase_user_uid)

        if user.blank?
          if request.path =~ %r{users/sign_up}
            logger.info("Signup process, setting new User instance as current_user")
            success!(User.new)
          else
            message = "Can't find User"
            logger.error(message, firebase_user_uid: firebase_user_uid)
            fail!(message)
          end
        else
          logger.info("Successfully authenticated User: ##{user.id}")
          success!(user)
        end
      rescue Authentication::AuthError => e
        fail!(e.message)
      end

      def store?
        false
      end

      private

      def jwt
        @jwt ||= Authentication::TokenProviders::Header.find_jwt(env)
      end

      # REVIEW: We can log absence of aut header here is needed
      # "Auth header not found (expected one of: #{AUTHORIZATION_KEYS}"
      def bearer_header_found?
        jwt.present?
      end

      def jwt_payload
        env[Authentication::API_USER_JWT_CONTENTS_ENV_KEY] ||=
          Authentication::Users::Token::Decoder.decode(jwt)
      end

      # NOTE: If you delete user from Firebase DB manually, and if user sign-up
      # again later (create new user in FB DB) his UID will change (obviously).
      # This exotic situation may be handled, but will require additional mess
      # with payload['firebase'] and DB record's meta analysis if you want
      # new FB user bind to existing in DB.
      def find_user(firebase_user_uid)
        logger.info("Looking for User by firebase_user_uid", firebase_user_uid: firebase_user_uid)
        logger.debug("Firebase payload: #{jwt_payload}")

        User.find_by(firebase_user_uid: firebase_user_uid)
      end
    end
  end
end
