module Travelingo
  module API
    class V1Root < Grape::API
      group do
        mount Travelingo::API::V1::Users
      end
    end
  end
end
