module RackRequestBlocker
  class Railtie < Rails::Railtie
    initializer "rack_request_blocker.configure_rails_initialization" do |app|
      app.middleware.insert_before("Rack::Sendfile", "RackRequestBlocker::Middleware")
    end
  end
end
