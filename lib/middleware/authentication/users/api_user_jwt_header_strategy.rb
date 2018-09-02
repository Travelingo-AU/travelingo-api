module Authentication::Users

  # HOOKS LIST
  # https://github.com/wardencommunity/warden/wiki/Callbacks
  # after_set_user
  # after_authentication
  # after_fetch
  # before_failure
  # after_failed_fetch
  # before_logout
  # on_request

  class ApiUserJwtHeaderStrategy < Warden::Strategies::Base
    include CommonLogging

    def valid?
      scope == :api_user && bearer_header_found?
    end

    # TODO: Rescue
    def authenticate!
      logger.info("Authenticating #{scope}")

      user = find_user(jwt_payload['sub'])

      if user.blank?
        if request.path =~ %r{users/sign_up}
          logger.info("Signup process, setting new User instance")
          success!(User.new)
        else
          handle_error("Unauthenticated")
        end
      else
        logger.info("Successfully authenticated User: ##{user.id}")
        success!(user)
      end
    rescue
      handle_error($!.message)
    end

    def store?
      false
    end

    private

    JWT_CONTENTS_ENV_KEY = 'api_user.jwt_payload'

    def raw_jwt
      @jwt_raw ||= Authentication::TokenProviders::Header.extract_jwt(env)
    end

    def bearer_header_found?
      raw_jwt.present?
    end

    def jwt_payload
      env[JWT_CONTENTS_ENV_KEY] ||= Authentication::Users::Token.decode(raw_jwt)
    end

    # NOTE: If you delete user from Firebase DB manually, and if user sign-up
    # again later (create new user in FB DB) his UID will change (obviously).
    # This exotic situation may be handled, but will require additional mess
    # with payload['firebase'] and DB record's meta analysis if you want
    # new FB user bind to existing in DB.
    def find_user(firebase_user_uid)
      logger.info("Looking for User by firebase_user_uid: #{firebase_user_uid}")
      User.find_by(firebase_user_uid: firebase_user_uid)
    end

    def handle_error(message)
      logger.error(message)
      fail!(message)
    end
  end
end

