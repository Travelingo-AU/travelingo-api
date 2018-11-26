module Authentication
  module Admins
    class EmailPasswordStrategy < Warden::Strategies::Base
      include SemanticLogger::Loggable

      def email
        params.dig('admin_user', 'email')
      end

      def password
        params.dig('admin_user', 'password')
      end

      def valid?
        logger.debug("Checking should authenticate", email: email, password: password)
        email && password
      end

      def authenticate!
        admin = AdminUser.find_by(email: email)
        logger.debug("Authenticating #{scope} scope", admin_email: email)
        return success!(admin) if admin && admin.authenticate(password)

        fail
      end
    end
  end
end
