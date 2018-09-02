module SpecHelpers
  module UserAuthJwtHelpers
    def test_jwt
      ENV!['TEST_FIREBASE_JWT']
    end

    # Time JWT is valid within
    def test_jwt_valid_time
      Time.parse(ENV!['TEST_FIREBASE_JWT_VALID_TIME'])
    end

    # used for CertRepository to find required cert
    def test_jwt_cert_kid
      ENV!['TEST_FIREBASE_JWT_CERT_KID']
    end

    # One-line
    def test_jwt_cert_raw
      ENV!['TEST_FIREBASE_JWT_CERT']
    end

    # Multiline
    def test_jwt_cert
      test_jwt_cert_raw
    end

    # Using for find User in DB
    def test_jwt_user_uid
      ENV!['TEST_FIREBASE_JWT_USER_UID']
    end

    # EXAMPLE: Getting result from method
    # payload, header = with_valid_jwt_time do
    #   decoder.decode
    # end
    def with_valid_jwt_time
      travel_to(test_jwt_valid_time) do
        return yield
      end
    end

    CERTS_DIR = ENV!['APP_ROOT'] + '/tmp/test_certs'

    def rm_certs_dir
      FileUtils.rm_r(CERTS_DIR) if Dir.exists?(CERTS_DIR)
    end

    def json_file_for_today
      CERTS_DIR + "#{Time.current.utc.strftime('%Y-%m-%d')}.json"
    end

    # NOTE: If test_jwt_cert_raw will be interpolated you will get json decode
    # error because of new-line escape sequence
    def stub_certs_request(body = nil)
      body ||= '{ "%s" : "%s" }' % [test_jwt_cert_kid, test_jwt_cert_raw]

      stub_request(:get, "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com")
        .to_return(body: body)
    end
  end
end

RSpec.configuration.include(SpecHelpers::UserAuthJwtHelpers, :user_jwt)
