module Authentication
  module Users
    module Grape
      def self.included(base)

        # NOTE: We use Grape on top of rails, so warden configuration
        # stored in RoR initializer (only one failure app may be present)

        base.helpers do
          def jwt_payload
            env[Authentication::API_USER_JWT_CONTENTS_ENV_KEY]
          end

          def current_user
            warden.user(:api_user)
          end

          def authenticate_user!
            warden.authenticate!(:user_jwt_header, scope: :api_user)
          end

          def warden
            env["warden"]
          end
        end

        base.before do
          authenticate_user!
        end
      end
    end
  end
end
