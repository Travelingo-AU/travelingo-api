FactoryBot.define do
  factory :firebase_cert do
    kid { ENV!['TEST_FIREBASE_JWT_CERT_KID'] }
    content { ENV!['TEST_FIREBASE_JWT_CERT'].gsub('\n', "\n").strip << "\n" }
  end

  factory :user do
    sequence(:email) { |n| "f-user-#{n}@example.com" }
    sequence(:full_name) { |n| "John Doe#{n}" }
    firebase_user_uid { Digest::MD5.hexdigest(Time.current.to_f.to_s) }
    firebase_meta(identities:       {},
                  sign_in_provider: 'anonymous')
  end
end
