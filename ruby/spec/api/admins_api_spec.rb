=begin
#Simple Inventory API

#This is a simple API

OpenAPI spec version: 1.0.0
Contact: you@your-company.com
Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.0

=end

require 'spec_helper'
require 'json'

# Unit tests for SwaggerClient::AdminsApi
# Automatically generated by swagger-codegen (github.com/swagger-api/swagger-codegen)
# Please update as you see appropriate
describe 'AdminsApi' do
  before do
    # run before each test
    @instance = SwaggerClient::AdminsApi.new
  end

  after do
    # run after each test
  end

  describe 'test an instance of AdminsApi' do
    it 'should create an instance of AdminsApi' do
      expect(@instance).to be_instance_of(SwaggerClient::AdminsApi)
    end
  end

  # unit tests for add_inventory
  # adds an inventory item
  # Adds an item to the system
  # @param [Hash] opts the optional parameters
  # @option opts [InventoryItem] :inventory_item Inventory item to add
  # @return [nil]
  describe 'add_inventory test' do
    it 'should work' do
      # assertion here. ref: https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
    end
  end

end