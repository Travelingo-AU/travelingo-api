ENV['RACK_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The RACK_ENV is set to production mode!") if ENV!.production?

#
# SETTING UP ENVIRONMENT
#

# This JWT was taken for testing. Please, keep it fixed.
# In worst case, env vars should be changed accordingly
#
# TODO: This solution is brittle, and these vars only needed for real User
# Firebase auth testing, the rest of tests use stubbed auth. Find out better
# developer-independent solution.
#
# Decoded token (additionally split by parts):
# Header:
#
# {"alg" => "RS256", "kid" => "a0ceb46742a63e19642163a7286dcd42f7436366"}
#
# Payload:
#
#  {"iss"            => "https://securetoken.google.com/dj-app2-3bf16",
#     "name"           => "Ivan Byurganovskiy",
#     "picture"        =>
#       "https://scontent.xx.fbcdn.net/v/t1.0-1/p100x100/12189808_10208563151544817_815941326244046854_n.jpg?oh=d642f5fce95c6256b02a7fe8dbc0eb34&oe=590AA4BE",
#     "aud"            => "dj-app2-3bf16",
#     "auth_time"      => 1535648116,
#     "user_id"        => "iJwb40xCJDPCgXOHztLz5ThxyJ82",
#     "sub"            => "iJwb40xCJDPCgXOHztLz5ThxyJ82",
#     "iat"            => 1535648116,
#     "exp"            => 1535651716,
#     "email"          => "edjbox@gmail.com",
#     "email_verified" => true,
#     "firebase"       =>
#       {"identities"       =>
#          {"google.com" => ["116936560063373783122"], "email" => ["edjbox@gmail.com"]},
#        "sign_in_provider" => "google.com"}}

ENV['TEST_FIREBASE_JWT']            = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImEwY2ViNDY3NDJhNjNlMTk2NDIxNjNhNzI4NmRjZDQyZjc0MzYzNjYifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZGotYXBwMi0zYmYxNiIsIm5hbWUiOiJJdmFuIEJ5dXJnYW5vdnNraXkiLCJwaWN0dXJlIjoiaHR0cHM6Ly9zY29udGVudC54eC5mYmNkbi5uZXQvdi90MS4wLTEvcDEwMHgxMDAvMTIxODk4MDhfMTAyMDg1NjMxNTE1NDQ4MTdfODE1OTQxMzI2MjQ0MDQ2ODU0X24uanBnP29oPWQ2NDJmNWZjZTk1YzYyNTZiMDJhN2ZlOGRiYzBlYjM0Jm9lPTU5MEFBNEJFIiwiYXVkIjoiZGotYXBwMi0zYmYxNiIsImF1dGhfdGltZSI6MTUzNTY0ODExNiwidXNlcl9pZCI6ImlKd2I0MHhDSkRQQ2dYT0h6dEx6NVRoeHlKODIiLCJzdWIiOiJpSndiNDB4Q0pEUENnWE9IenRMejVUaHh5SjgyIiwiaWF0IjoxNTM1NjQ4MTE2LCJleHAiOjE1MzU2NTE3MTYsImVtYWlsIjoiZWRqYm94QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7Imdvb2dsZS5jb20iOlsiMTE2OTM2NTYwMDYzMzczNzgzMTIyIl0sImVtYWlsIjpbImVkamJveEBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJnb29nbGUuY29tIn19.M-3S6my2TlevPANNKKImem-hEm_XTRLjimRYGjbY6cS1RbfmiLfAxiA7iPZW3X2dRxIKEuwedbEk5-KRFI-nhEshTkHg7avpaUG3ev2A5QxK-VmTBB0eIzg2SGl6jhGcuIVGPg6D4R69OKfsYnETOi3g9gTlJy3PsBWJvKxVjnCNB4bX_JOVcVdOttpuoh803uDqFl-svj493yI1gE79Zoq8zMSYFT58E0Xq83f6fz7dhcGMv6fvK8puw5clswqFjfLkWN4B49ZzpeSeqPJLDZkil2Qq0O9ZgqaTKK2C5ziJxUP206hJj2gt1AawtP_y3Euzt3dovhiZGGqlVdF8Mg'
ENV['TEST_FIREBASE_JWT_VALID_TIME'] = '2018-08-30 17:00:00 UTC'
ENV['TEST_FIREBASE_JWT_CERT_KID']   = 'a0ceb46742a63e19642163a7286dcd42f7436366'
ENV['TEST_FIREBASE_JWT_CERT']       = '-----BEGIN CERTIFICATE-----\nMIIDHDCCAgSgAwIBAgIIeSJTTBAicewwDQYJKoZIhvcNAQEFBQAwMTEvMC0GA1UE\nAxMmc2VjdXJldG9rZW4uc3lzdGVtLmdzZXJ2aWNlYWNjb3VudC5jb20wHhcNMTgw\nODI5MjEyMDI5WhcNMTgwOTE1MDkzNTI5WjAxMS8wLQYDVQQDEyZzZWN1cmV0b2tl\nbi5zeXN0ZW0uZ3NlcnZpY2VhY2NvdW50LmNvbTCCASIwDQYJKoZIhvcNAQEBBQAD\nggEPADCCAQoCggEBAJJRdQKSbD0gG+WBAETzX3GlpnxpCg5Ad2DiCFj4ecRvXPrP\nWsp49tx0ussmEGbIor34aGpawCtrd232Jb6aUrvL5c3CSmO81LTM7W2kAKBLvBld\n/r4pZSF5xDzKDTAIUsPC98VHLE1LnYUtBpdALF8mj/Ujt2PmdDVaPMtPnKvMuvYS\ny0cwj2JubQ/TP8K+nmnMqM5ZPqhL7gV7PiMLGl3v7o8KElX/2ToxdbKUuw10Rqbs\n/BbPEuAbFB9ELnDl7g+m2QlEekPw9I1QEQNoqJ833cVjx9ERPn0vjFsbiCMLGUWu\n2/CcHvA7u9f6g2+RXEDv/DrKHhzzGRmLvfmzEyUCAwEAAaM4MDYwDAYDVR0TAQH/\nBAIwADAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwIwDQYJ\nKoZIhvcNAQEFBQADggEBAC+4JwUo01FNTdoldzVVCAjnUfXzOAq5Y4HNfz6xUDLK\n9rTCZ7mZEJ35xqaFX0+A1ETT4pCD9AOk0O/LcIo1QM0BHjCkTBqTvA087nOAWlwT\n/0oBgRFn4va4yEC5XIBkNBhOOA26dQGl/NaOUotHpsjsEjJzXlPl/A2aJx1CgHCQ\nz4WAzn7IrVk1zQGsNxWIrpoOtwR9Op+ztc/yvddvH1nUFQJb45M/V4YxrAhxqAbA\njmeuXwnrUY2ZqYVU3fshpN7aLTySNINIjtPaki/nSiY6HlTttZvqPEJHA3TbmZbu\nhEKaPf0iVFJh28KbLof8GB0SSSGSv2mmv8SXliRotg0=\n-----END CERTIFICATE-----\n'
ENV['TEST_FIREBASE_JWT_USER_UID']   = 'iJwb40xCJDPCgXOHztLz5ThxyJ82'

# Add to envbang, so we can use its features in specs and factories
# Google's certificates URL: https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com

ENV!.config do
  use :TEST_FIREBASE_JWT, 'Example JWT token (comes from Firebase)'
  use :TEST_FIREBASE_JWT_VALID_TIME, 'Time @ which token is still valid (please keep it simple, e.g. 017-01-14 17:00:00 UTC)'
  use :TEST_FIREBASE_JWT_CERT, 'Google certificate used to verify sign for token (valid and updated each 3 days)'
  use :TEST_FIREBASE_JWT_CERT_KID, 'Google certificate ID'
  use :TEST_FIREBASE_JWT_USER_UID, 'Firebase user UID'
end

# This is required for tests to pass (same as JWT's `iss` field)

ENV['FIREBASE_PROJECT_ID'] = 'dj-app2-3bf16'

#
# DEPENDENCIES
#

# require 'capybara/rspec'
require 'rspec/rails'
require 'database_rewinder'
require 'factory_bot'
require 'json_expressions/rspec'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir["#{ENV!['APP_ROOT']}/spec/support/**/*.rb"].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
if ENV['TEST_CHECK_PENDING_MIGRATIONS'] == 1
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
end

#
# ADJUST GEMS BEFORE TESTING
#

# If you need 'mail' gem matchers (I found them strangely organized and not
# strict enough) you can use:
# RSpec.configuration.include(::Mail::Matchers, :mail)
# https://github.com/mikel/mail/#using-mail-with-testing-or-specing-libraries

RSpec.configure do |config|
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  if ENV['TEST_PROFILE']
    config.profile_examples = 15
  end

  # FILTERING

  config.run_all_when_everything_filtered = true

  if ENV['TEST_FORCE_ALL'] == 1
    # this MAY override CLI args
    # config.filter_run_including(nil)
    # this WILL override CLI args
    config.inclusion_filter = nil
  end

  # MODULES

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers

  # HOOKS

  config.before(:suite) do
    DatabaseRewinder.init

    # TODO: Unsure it works
    # Do not clean this table
    DatabaseRewinder['test'].except = %w[ar_internal_metadata]

    # Make sure nothing left if lint fails
    # https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories
    if ENV['TEST_LINT_FACTORIES'] == 1
      begin
        # TODO: traits:true does not work (version mismatch?)
        FactoryBot.lint
      ensure
        DatabaseRewinder.clean_all
      end
    else
      DatabaseRewinder.clean_all
    end

    FactoryBot.reload
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # NOTE: We will need it once we add capybara+js specs.
  # Having examples wrapped in transactions is enough for now
  # See https://github.com/amatsuda/database_rewinder#1-properly-understand-what-use_transactional_tests-means-and-consider-turning-it-off
  # config.after(:each) do
  #   # Delete from affected tables
  #   # https://github.com/amatsuda/database_rewinder
  #   DatabaseRewinder.clean
  # end

  config.before(:each) do |ex|
    SpecLogger.logger.info("\n\n>>>> EXAMPLE STARTED >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n")
  end

  config.after(:each) do
    SpecLogger.logger.info("\n\n<<<< EXAMPLE ENDED <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
  end

  config.around(:each, :mail) do |ex|
    SpecLogger.logger.info(">>>> Cleaning emails before test\n")
    Mail::TestMailer.deliveries.clear
    ex.run
    SpecLogger.logger.info("\n<<<< Cleaning emails after test")
    Mail::TestMailer.deliveries.clear
  end

  config.after(:each, %i[api_spec web_spec]) do
    SpecLogger.logger.info("Warden reset")
    Warden.test_reset!
  end

  #
  # CUSTOMIZING RSPEC
  #

  config.alias_example_to :request_result

  #
  # DEFAULT RSPEC STUFF
  #

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = "tmp/spec_example_status.txt"

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  # config.filter_run :focus
  # config.run_all_when_everything_filtered = true

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  config.expose_dsl_globally = false
  config.fail_if_no_examples = true

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 10 slowest examples and example groups at the
  # end of the spec run, to help surface which specs are running
  # particularly slow.
  # config.profile_examples = 10

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
