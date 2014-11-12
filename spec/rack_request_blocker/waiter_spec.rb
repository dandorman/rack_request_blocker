module RackRequestBlocker
  describe Waiter do
    let(:middleware) { spy("middleware", active_request_count: 0) }
    let(:session) { spy("session") }

    subject(:waiter) { Waiter.new(session, middleware) }

    describe "#wait" do
      it "directs the session to an 'about:blank' page" do
        waiter.wait
        expect(session).to have_received(:execute_script).with(/about:blank/)
      end

      it "tells the middleware to allow requests after blocking them" do
        waiter.wait
        expect(middleware).to have_received(:block_requests).ordered
        expect(middleware).to have_received(:allow_requests).ordered
      end

      it "raises a Timeout::Error after 30 seconds" do
        allow(Timeout).to receive(:timeout).with(30).and_raise(Timeout::Error)
        expect { waiter.wait }.to raise_error(Timeout::Error)
      end
    end
  end
end
