module Travelingo
  module API
    module V1
      class Users < Grape::API
        namespace :users do
          desc 'Return a public timeline.'
          get :test do
            present('201')
          end
        end
      end
    end
  end
end
