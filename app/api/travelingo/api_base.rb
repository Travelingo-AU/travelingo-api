module Travelingo
  class APIBase < Grape::API
    default_format :json
    format :json

    desc 'Return a public timeline.'
    get :test do
      present('ok')
    end

    mount Travelingo::API::V1Root => '/v1'
  end
end
