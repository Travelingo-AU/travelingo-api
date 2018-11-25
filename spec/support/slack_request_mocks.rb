module SpecHelpers
  module SlackRequestMocks
    def mock_successful_new_user_sign_up_slack_notification
      stub_request(:post, ENV!['NOTIFICATIONS_NEW_USER_SIGN_UP_WEBHOOK_URL']).to_return(body: 'ok', status: 200)
    end
  end
end

RSpec.configuration.include(SpecHelpers::SlackRequestMocks, :slack_stubs)
