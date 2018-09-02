require 'spec_helper'

RSpec.describe "[AUTH/USER] User sign-up", :api_spec, :user, :auth, :user_jwt do

  let(:token) { test_jwt }
  let(:auth_header) { bearer_header(token) }
  let(:new_user) { User.first }

  # This params will override the ones stored in JWT payload
  let(:params) do
    {email:     'email@example.com',
     full_name: 'John Doe',
     dob:       '01/01/2001',
     mobile:    '+61 491 570 156'}
  end

  describe "success:", :focus do

    let!(:fb_cert_record) { create(:firebase_cert) }

    example "verify token and create new user" do
      with_valid_jwt_time do
        post '/api/v1/users/sign_up', params, auth_header
      end

      json_pattern = {full_name: /John/}.ignore_extra_keys

      aggregate_failures "response with valid JSON" do
        expect_successful_response
        expect_response_to_match_json(json_pattern)
      end

      expect(User.count).to eq(1), "User was not created"

      aggregate_failures "User created and JWT payload saved" do
        expect(new_user.full_name).to match /John/ # NOTE: params override JWT's one
        expect(new_user.email).to match /example/
        expect(new_user.firebase_user_uid).to eq test_jwt_user_uid
        expect(new_user.firebase_meta).to be_kind_of Hash
        expect(new_user.firebase_meta).not_to be_blank
        expect(new_user.identities).to be_kind_of Hash
        expect(new_user.sign_in_provider).to match /google/
      end
    end
  end

  describe "errors:" do
    let!(:fb_cert_record) { create(:firebase_cert) }

    example "token expired" do
      get '/api/v1/users/sign_up', nil, auth_header

      aggregate_failures "response with valid JSON" do
        expect_response_json_to_have_error(/signature has expired/i)
        expect(last_response.status).to eq 401
      end
    end
  end
end
