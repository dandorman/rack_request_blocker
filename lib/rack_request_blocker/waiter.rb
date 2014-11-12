require "timeout"

module RackRequestBlocker
  class Waiter
    # Public: Returns an initalized Waiter instance.
    #
    # session       - A Capybara::Session object.
    # request_state - An object which keeps track of the number of active
    #                 requests and can block them. Needs to respond to
    #                 #active_request_count, #block_requests, and
    #                 #allow_requests messages.  (Default is
    #                 RackRequestBlocker::Middleware.)
    def initialize(session, request_state = Middleware)
      @session = session
      @request_state = request_state
    end

    # Public: Block any further requests, then wait until any in-flight
    # requests return before re-enabling requests and returning.
    #
    # wait:     - An Integer representing the number of seconds to wait before
    #             blowing up. (Default: 30.)
    # interval: - A Float representing the number of seconds to wait in between
    #             active-request–count checks. (Default: 0.01.)
    #
    # Returns nothing.
    def wait(time: 30, interval: 0.01)
      stop_client
      @request_state.block_requests
      wait_for(time: time, interval: interval) do
        @request_state.active_request_count == 0
      end
    ensure
      @request_state.allow_requests
    end

    private

    # Internal: Redirects the session's client to the "about:blank" page.
    #
    # Returns nothing.
    def stop_client
      @session.execute_script %Q{
        window.location = "about:blank";
      }
    end

    # Internal: Performs the actual waiting, using Ruby's standard Timeout.
    #
    # wait:     - An Integer representing the number of seconds to wait before
    #             blowing up.
    # interval: - A Float representing the number of seconds to wait in between
    #             active-request–count checks.
    #
    # Returns nothing.
    def wait_for(time:, interval:)
      Timeout.timeout(time) do
        while true
          return if yield
          sleep(interval)
        end
      end
    end
  end
end
