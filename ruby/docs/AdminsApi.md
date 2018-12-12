# SwaggerClient::AdminsApi

All URIs are relative to *https://virtserver.swaggerhub.com/Travelingo/Travelingo-API-V1/1.0.0*

Method | HTTP request | Description
------------- | ------------- | -------------
[**add_inventory**](AdminsApi.md#add_inventory) | **POST** /inventory | adds an inventory item


# **add_inventory**
> add_inventory(opts)

adds an inventory item

Adds an item to the system

### Example
```ruby
# load the gem
require 'swagger_client'

api_instance = SwaggerClient::AdminsApi.new

opts = { 
  inventory_item: SwaggerClient::InventoryItem.new # InventoryItem | Inventory item to add
}

begin
  #adds an inventory item
  api_instance.add_inventory(opts)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling AdminsApi->add_inventory: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inventory_item** | [**InventoryItem**](InventoryItem.md)| Inventory item to add | [optional] 

### Return type

nil (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



