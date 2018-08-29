module Travelingo
  module API
    class V1Root < Grape::API
      desc 'Return a public timeline.'
      get :test do
        present('200')
      end

      group do
        mount Travelingo::API::V1::Users
      end
    end
  end
end
