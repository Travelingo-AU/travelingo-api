module SpecHelpers
  module AuthHelpers
    include Warden::Test::Helpers

    def login_as_user(user)
      SpecLogger.logger.info("Logging in as USER: #{user.id}")
      login_as(user, scope: :api_user)
    end
  end
end


RSpec.configuration.include(SpecHelpers::AuthHelpers, :api_spec, :web_spec)
