=begin
#Simple Inventory API

#This is a simple API

OpenAPI spec version: 1.0.0
Contact: you@your-company.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0

=end

require 'uri'

module SwaggerClient
  class AdminsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # adds an inventory item
    # Adds an item to the system
    # @param [Hash] opts the optional parameters
    # @option opts [InventoryItem] :inventory_item Inventory item to add
    # @return [nil]
    def add_inventory(opts = {})
      add_inventory_with_http_info(opts)
      nil
    end

    # adds an inventory item
    # Adds an item to the system
    # @param [Hash] opts the optional parameters
    # @option opts [InventoryItem] :inventory_item Inventory item to add
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def add_inventory_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: AdminsApi.add_inventory ...'
      end
      # resource path
      local_var_path = '/inventory'

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(opts[:'inventory_item'])
      auth_names = []
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: AdminsApi#add_inventory\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
