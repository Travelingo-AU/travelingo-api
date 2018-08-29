module Travelingo
  class APIBase < Grape::API
    default_format :json
    format :json

    #
    # LOGGING & ERRORS
    #

    # See https://github.com/aserafin/grape_logging
    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }

    helpers do
      def logger
        Travelingo::APIBase.logger
      end

      def api_error!(message, status: nil, headers: {})
        if message.is_a?(StandardError)
          message = {
            error:      message.message,
            error_type: message.class.to_s}
        end

        error!(message, status, headers)
      end
    end

    error_formatter :json, -> (message, _backtrace, _options, _env, _original_exception) {
      (message.is_a?(Hash) ? message : {error: message}).to_json
    }

    rescue_from :all do |exception|
      api_error!(exception, status: 500)
    end

    # MIDDLEWARE

    use Rack::Cors do
      allow do
        origins '*'
        resource '/*',
                 headers: :any,
                 methods: [:get, :post, :put, :patch, :delete, :options],
                 expose:  ['access-token', 'token-type', 'client', 'expiry', 'uid']
      end
    end

    # ROUTES

    desc 'Return a public timeline.'
    get :test do
      present('ok')
    end

    mount Travelingo::API::V1Root => '/v1'

    # DOCS IN DEV MODE

    if ENV!.development?
      add_swagger_documentation(
        format:     :json, base_path: '/api/v1',
        mount_path: '/docs', hide_documentation_path: true)
    end
  end
end
