module Authentication
  AuthError = Class.new(StandardError)

  API_USER_JWT_CONTENTS_ENV_KEY = 'api_user.jwt_payload'
end
