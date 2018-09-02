module Travelingo
  module API
    class V1Root < Grape::API
      group do
        include Authentication::Users::Grape

        mount Travelingo::API::V1::Users::AuthAPI
      end
    end
  end
end
