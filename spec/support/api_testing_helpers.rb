module SpecHelpers
  module ApiTestingHelpers
    include Rack::Test::Methods

    # Hash with one of auth headers + value string
    def bearer_header(jwt)
      {%w[HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION].sample => "Bearer #{jwt}"}
    end

    def json_response
      JSON.parse(last_response.body) rescue nil
    end

    def expect_response_to_match_json(response_pattern)
      expect(json_response).to match_json_expression(data: response_pattern)
    end

    def expect_response_not_to_match_json(response_pattern)
      expect(json_response).not_to match_json_expression(data: response_pattern)
    end

    def expect_response_json_to_have_error(error_message, error_type = nil)
      pattern = {error: error_message}.ignore_extra_keys
      pattern.merge!(error_type: error_type.to_s) if error_type
      expect(json_response).to match_json_expression(pattern)
    end

    # See cheatsheet for list fo statuses
    # http://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option
    # - 405 - :method_not_allowed
    # - 422 - :unprocessable_entity
    def expect_successful_response
      # Not using be_between here
      expect(last_response.status).to satisfy("status to be successful (within 200...300)") do |status|
        status >= 200 && status < 300
      end
    end

    def expect_failure_response
      expect(last_response.status).to satisfy("status to be failure (>= 400)") do |status|
        status >= 400
      end
    end

    # These two taken from airborne
    def expect_header(key, content)
      expect_header_impl(key, content)
    end

    def expect_header_contains(key, content)
      expect_header_impl(key, content, true)
    end

    private

    def expect_header_impl(key, content, contains = nil)
      header = last_response.headers[key]
      if header
        if contains
          expect(header.downcase).to include(content.downcase)
        else
          expect(header.downcase).to eq(content.downcase)
        end
      else
        msg = "Header #{key} not present in the HTTP response. These ones does: "
        msg += last_response.headers.inspect
        fail RSpec::Expectations::ExpectationNotMetError, msg
      end
    end
  end
end

RSpec.configuration.include(SpecHelpers::ApiTestingHelpers, :api_spec)
