ENV!.config do
  # Turn magic off: https://github.com/jcamenisch/ENV_BANG#default-type-conversion-behavior
  default_class String

  use :APP_URL
  use :NEW_USER_SIGN_UP_WEBHOOK_URL

  use :APP_DB_HOST
  use :APP_DB_PORT
  use :APP_DB_NAME
  use :APP_DB_USER
  use :APP_DB_PASSWORD

  use :APP_ROOT, default: File.expand_path("#{__dir__}/..")
  use :RACK_ENV, default: 'development'
  use :FIREBASE_PROJECT_ID
end

class ENV_BANG
  class << self
    %i[production? test? development?].each do |method_name|
      define_method method_name do
        self['RACK_ENV'] == method_name[0..-2] # slicing convert Symbol to string
      end
    end

    def app_root
      Rails.root
    end
  end
end
