require "atomic"

module RackRequestBlocker
  class Middleware
    # Public: Returns an Atomic Integer representing the number of active
    # requests.
    def self.active_requests
      @active_requests ||= Atomic.new(0)
    end

    # Public: Access to the value stored in `@active_requests`.
    def self.active_request_count
      active_requests.value
    end

    # Public: Returns an Atomic boolean representing whether to block incoming
    # requests.
    def self.request_blocker
      @request_blocker ||= Atomic.new(false)
    end

    # Public: Disable further requests.
    #
    # Returns nothing.
    def self.block_requests
      request_blocker.update { true }
    end

    # Public: Enable further requests.
    #
    # Returns nothing.
    def self.allow_requests
      request_blocker.update { false }
    end

    # Public: Initializes the Middleware.
    #
    # app - A Rack application.
    # active_requests: - Blurgh.
    # request_blocker: - Blurgh.
    #
    # Returns nothing.
    def initialize(app,
                   active_requests: self.class.active_requests,
                   request_blocker: self.class.request_blocker)
      @app = app
      @active_requests = active_requests
      @request_blocker = request_blocker
    end

    # Public: Calls the middleware.
    #
    # env - A Hash of environment variables.
    #
    # Returns a Rack response, a three-element array representing the status
    # code, headers, and body of the response.
    def call(env)
      increment_active_requests
      if block_requests?
        block_request
      else
        @app.call(env)
      end
    ensure
      decrement_active_requests
    end

    private

    # Internal: Increment the number of active requests.
    #
    # Returns nothing.
    def increment_active_requests
      @active_requests.update { |count| count + 1 }
    end

    # Internal: Decrement the number of active requests.
    #
    # Returns nothing.
    def decrement_active_requests
      @active_requests.update { |count| count - 1 }
    end

    # Internal: Whether to block incoming requests.
    def block_requests?
      @request_blocker.value
    end

    # Internal: Generate a 503 Service Unavailable response.
    #
    # env - A Hash of environment variables.
    #
    # Returns a Rack response with a 503 status.
    def block_request
      [503, {}, []]
    end
  end
end
