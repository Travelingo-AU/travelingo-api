# SwaggerClient::DevelopersApi

All URIs are relative to *https://virtserver.swaggerhub.com/Travelingo/Travelingo-API-V1/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**search_inventory**](DevelopersApi.md#search_inventory) | **GET** /inventory | searches inventory


# **search_inventory**
> Array&lt;InventoryItem&gt; search_inventory(opts)

searches inventory

By passing in the appropriate options, you can search for available inventory in the system 

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::DevelopersApi.new

opts = { 
  search_string: 'search_string_example', # String | pass an optional search string for looking up inventory
  skip: 56, # Integer | number of records to skip for pagination
  limit: 56 # Integer | maximum number of records to return
}

begin
  #searches inventory
  result = api_instance.search_inventory(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling DevelopersApi->search_inventory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search_string** | **String**| pass an optional search string for looking up inventory | [optional] 
 **skip** | **Integer**| number of records to skip for pagination | [optional] 
 **limit** | **Integer**| maximum number of records to return | [optional] 

### Return type

[**Array&lt;InventoryItem&gt;**](InventoryItem.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json



