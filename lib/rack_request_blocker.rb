require "rack_request_blocker/version"
require "rack_request_blocker/middleware"
require "rack_request_blocker/waiter"

require "rack_request_blocker/railtie" if defined?(Rails)
