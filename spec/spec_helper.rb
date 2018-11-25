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
# {
#   "header"  => {
#     "alg" => "RS256",
#     "kid" => "9a2d76dcc3e5c72673868119375cc55c678b7e46"}
#   },
#   "payload" => {
#     "iss"       => "https://securetoken.google.com/dj-app2-3bf16",
#     "name"      => "Ivan Byurganovskiy",
#     "picture"   => "https://lh3.googleusercontent.com/-P1uQuWKADhU/AAAAAAAAAAI/AAAAAAAAAAA/AKB_U8sAa3doYl0iz0YNZvYXELsyQGCaWA/s96-c/photo.jpg",
#     "aud"       => "dj-app2-3bf16",
#     "auth_time" => 1484410712,
#     "user_id"   => "j7qfTm1Ecedc8qZi8Wys8BzXHeb2",
#     "sub"       => "j7qfTm1Ecedc8qZi8Wys8BzXHeb2",
#     "iat"       => 1484410712,
#     "exp"       => 1484414312,
#     "firebase"  => {
#       "identities"       => {"google.com" => ["116936560063373783122"]},
#       "sign_in_provider" => "google.com"}
#     }
#   }
# }

ENV['TEST_FIREBASE_JWT']                = File.read("#{__dir__}/fixtures/firebase/user_jwt.txt").chomp
ENV['TEST_FIREBASE_JWT_CERT']           = File.read("#{__dir__}/fixtures/firebase/firebase_cert.txt").chomp
ENV['TEST_FIREBASE_JWT_VALID_DATETIME'] = '2017-01-14 17:00:00 UTC'
ENV['TEST_FIREBASE_JWT_CERT_KID']       = '9a2d76dcc3e5c72673868119375cc55c678b7e46'
ENV['TEST_FIREBASE_JWT_SUB']            = 'j7qfTm1Ecedc8qZi8Wys8BzXHeb2'

# Add to envbang, so we can use its features in specs and factories
# Google's certificates URL: https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com

ENV!.config do
  use :TEST_FIREBASE_JWT, 'Example JWT token (comes from Firebase)'
  use :TEST_FIREBASE_JWT_VALID_DATETIME, 'Time @ which token is still valid (please keep it simple, e.g. 017-01-14 17:00:00 UTC)'
  use :TEST_FIREBASE_JWT_CERT, 'Google certificate used to verify sign for token (valid and updated each 3 days)'
  use :TEST_FIREBASE_JWT_CERT_KID, 'Google certificate ID'
  use :TEST_FIREBASE_JWT_SUB, 'Firebase user UID'
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
    SpecLogger.logger.info(">>>> EXAMPLE STARTED >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
  end

  config.after(:each) do
    SpecLogger.logger.info("<<<< EXAMPLE ENDED <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
  end

  config.around(:each, :mail) do |ex|
    SpecLogger.logger.info(">>>> Cleaning emails before test")
    Mail::TestMailer.deliveries.clear
    ex.run
    SpecLogger.logger.info("<<<< Cleaning emails after test")
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
