module Travelingo::API::V1::Users
  class AuthAPI < Grape::API
    namespace :users do

      #
      # SIGN-UP
      #

      desc "USER sign-up"

      # You can add custom User's params here if needed
      params do
        requires :email, type: String
        requires :full_name, type: String
        requires :dob, type: String
        requires :mobile, type: String
      end

      # TODO: Do we need detailed validation errors JSON report?
      post :sign_up do
        if current_user.new_record?
          begin
            current_user.assign_attributes_from_jwt_payload(jwt_payload)
            current_user.assign_attributes(declared(params))
            current_user.save!

            body(data: present(current_user))
          rescue ActiveRecord::RecordInvalid => e
            api_error!(e, status: :bad_request)
          end
        else
          api_error!('USER already registered', status: :bad_request)
        end
      end

      #
      # SIGN-IN
      #

      desc "USER sign-in"

      # Updating user attributes from payload
      post :sign_in do
        begin
          current_user.assign_attributes_from_jwt_payload(jwt_payload)
          current_user.save! # will not be triggered if not changed

          body(data: present(current_user))
        rescue ActiveRecord::RecordInvalid => e
          api_error!(e, status: :bad_request)
        end
      end
    end
  end
end
