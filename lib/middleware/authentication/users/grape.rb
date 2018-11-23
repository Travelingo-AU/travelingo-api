module Authentication
  module Users
    module Grape
      def self.included(base)

        # See https://github.com/wardencommunity/warden/wiki/Setup

        base.use Warden::Manager do |config|
          # Thrown symbol will be handled by `Grape::Middleware::Error#error_response`
          config.failure_app = ->(env) do
            throw :error, status: 401, message: env["warden.options"].fetch(:message)
          end

          config.default_scope = :api_user
          config.scope_defaults :api_user, strategies: [:api_user_jwt_header_strategy]
        end

        base.helpers do
          def jwt_payload
            env[Authentication::API_USER_JWT_CONTENTS_ENV_KEY]
          end

          def current_user
            warden.user(:api_user)
          end

          def authenticate_user!
            warden.authenticate!(scope: :api_user)
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
