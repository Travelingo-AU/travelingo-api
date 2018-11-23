require 'semantic_logger'
require 'grape'

# Partially based on https://github.com/ridiculous/grape-middleware-logger/blob/master/lib/grape/middleware/logger.rb

class APIEndpointProcessingReporter < Grape::Middleware::Globals
  include SemanticLogger::Loggable

  self.logger = SemanticLogger['Grape']

  BACKSLASH                = '/'.freeze
  DEFAULT_PARAMS_TO_FILTER = %w[password password_confirmation]

  # TODO
  # - take a precise look at #request_id method comments
  # - allow custom params filter list (, filter_params: [], filter_headers: [])
  # - filter headers

  def initialize(_env, **opts)
    super

    # TODO: Drop
    @options[:headers] = :all
  end

  def before
    super # sets env['grape.*']

    start_time

    logger.info "Processing request",
                method: env[Grape::Env::GRAPE_REQUEST].request_method,
                path:   env[Grape::Env::GRAPE_REQUEST].path,
                params: params_dump,
                ep:     processed_by

    logger.debug "Request headers", headers: headers_dump
  end

  # TODO: This is just ugly code (not mine :) )!
  # @note Error and exception handling are required for the +after+ hooks
  #   Exceptions are logged as a 500 status and re-raised
  #   Other "errors" are caught, logged and re-thrown
  def call!(env)
    @env = env

    logger.tagged(request_id: request_id) do
      before
      caught_error = catch(:error) do
        begin
          @app_response = @app.call(@env)
        rescue => e
          after_exception(e)
          raise e
        end
        nil
      end

      if caught_error
        after_failure(caught_error)
        throw(:error, caught_error)
      else
        http_status, _, _ = *@app_response
        after(http_status)
      end

      return @app_response
    end
  end

  def after(http_status)
    # Payload maybe useful for performance measuring using NOSQL-DBs queries
    logger.info "Request completed with #{http_status} status in #{end_time}ms",
                http_status:      http_status,
                request_end_time: end_time
  end

  #
  # Helpers
  #

  def start_time
    @start_time ||= Time.now
  end

  def end_time
    @end_time ||= ((Time.now - start_time) * 1000).round(2)
  end

  # TODO: Semantic Logger adds this file (`logger.error` call) as the
  # source of error, but it's not right, it should take it from exception
  def after_exception(e)
    logger.error "Error processing request", e.message, e
    after(500)
  end

  def after_failure(error)
    if error[:message]
      logger.error "Error processing request",
                   message:     error[:message],
                   http_status: error[:status]
    end

    after(error[:status])
  end

  # TODO: I'm really not sure this will work with Puma,
  # check ActionDispatch::RequestId solution
  # Gem: https://github.com/anveo/rack-request-id
  # Another solution from Heroku: https://github.com/Octo-Labs/heroku-request-id/blob/master/lib/heroku-request-id/middleware.rb
  def request_id
    # This one set by Rack::RequestId middleware
    Thread.current[:request_id]
  end

  def params_dump
    request_params = env[Grape::Env::GRAPE_REQUEST_PARAMS].to_hash
    request_params.merge! env[Grape::Env::RACK_REQUEST_FORM_HASH] if env[Grape::Env::RACK_REQUEST_FORM_HASH]

    # We can skip check if there is a param names in to filter list,
    # 'cause it's always so (passwords e.g.)
    request_params.reject { |k, _| DEFAULT_PARAMS_TO_FILTER.include?(k.to_s) }
  end

  def headers_dump
    request_headers = env[Grape::Env::GRAPE_REQUEST_HEADERS].to_hash
    return Hash[request_headers.sort] if @options[:headers] == :all

    headers_needed = Array(@options[:headers])
    result         = {}
    headers_needed.each do |need|
      result.merge!(request_headers.select { |key, value| need.to_s.casecmp(key).zero? })
    end
    Hash[result.sort]
  end

  def processed_by
    endpoint = env[Grape::Env::API_ENDPOINT]
    result   = []
    if endpoint.namespace == BACKSLASH
      result << ''
    else
      result << endpoint.namespace
    end
    result.concat endpoint.options[:path].map { |path| path.to_s.sub(BACKSLASH, '') }
    endpoint.options[:for].to_s << result.join(BACKSLASH)
  end
end
