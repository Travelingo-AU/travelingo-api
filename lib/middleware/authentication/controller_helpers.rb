module Authentication
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      def warden
        request.env['warden']
      end

      def current_admin
        warden.user(:admin)
      end

      def authenticate_admin!
        unless authenticate_admin
          redirect_to(admin_sign_in_path, flash: {error: "You need to be authenticated to access this page"})
        end
      end

      def authenticate_admin
        warden.authenticate(:admin_email_password, scope: :admin)
      end

      def admin_authenticated?
        warden.authenticated?(:admin)
      end

      helper_method :current_admin, :admin_authenticated?
    end
  end
end
