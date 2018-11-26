module Authentication
  class FailureApp
    def self.call(env)
      request = Rack::Request.new(env)

      if request.path =~ %r{^/api/}
        body = JSON.generate({error: env["warden.options"].fetch(:message)})
        # TODO: Call grape EP here
        [401, {'Content-Type' => 'text/json'}, [body]]
      else
        Admin::SessionsController.action(:new).call(env)
      end
    end
  end
end
