require 'spec_helper'

RSpec.describe "[API AUTH/USER] User sign-in", :api_spec, :user, :auth, :user_jwt do

  let(:token) { test_jwt }
  let(:auth_header) { bearer_header(token) }

  describe "success:" do

    let!(:fb_cert_record) { create(:firebase_cert) }
    let!(:user) do
      create(:user, firebase_user_uid: test_jwt_user_uid)
    end

    example "verify token and update existing user with FB meta" do
      with_valid_jwt_time do
        post '/api/v1/users/sign_in', nil, auth_header
      end

      json_pattern = {full_name: /John/}.ignore_extra_keys

      aggregate_failures "response with valid JSON" do
        expect_successful_response
        expect_response_to_match_json(json_pattern)
      end

      expect(User.count).to eq(1), "Users count changed"

      aggregate_failures "User updated with new JWT payload content" do
        user.reload

        expect(user.full_name).to match /John/
        expect(user.firebase_user_uid).to eq test_jwt_user_uid
        expect(user.email).to match /example/

        expect(user.identities).to have_key('google.com')
        expect(user.sign_in_provider).to match /google/
        expect(user.picture_url).to be_present
      end
    end
  end

  describe "errors:" do
    let!(:fb_cert_record) { create(:firebase_cert) }

    example "token expired" do
      get '/api/v1/users/sign_in', nil, auth_header

      aggregate_failures "response with valid JSON" do
        expect_response_json_to_have_error(/signature has expired/i)
        expect(last_response.status).to eq 401
      end
    end
  end
end
