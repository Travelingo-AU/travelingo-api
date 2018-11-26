#
# ACTIVE ADMIN AUTHENTICATION
#

Warden::Strategies.add(:admin_email_password, Authentication::Admins::EmailPasswordStrategy)

# Or better use Digest::SHA1.hexdigest (require new users's table column)

Warden::Manager.serialize_into_session(:admin) do |admin|
  admin.id
end

Warden::Manager.serialize_from_session(:admin) do |id|
  Rails.logger.debug("Restoring Admin from session", admin_id: id)
  AdminUser.find_by(id: id)
end

Rails.application.config.middleware.insert_after(ActionDispatch::Session::CookieStore, Warden::Manager) do |manager|
  manager.default_scope = :nope_use_strict_scope!

  manager.scope_defaults :admin, strategies: [:admin_email_password]
  manager.scope_defaults :api_user, strategies: [:user_jwt_header], action: '/fail'

  manager.failure_app = Authentication::FailureApp
end

#
# API AUTHENTICATION
#

Warden::Strategies.add(:user_jwt_header, Authentication::Users::JwtHeaderStrategy)
