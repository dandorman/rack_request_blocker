require "rack_request_blocker"

module RackRequestBlocker
  describe Middleware do
    before(:each) do
      RackRequestBlocker::Middleware.active_request_count.update { 0 }
      RackRequestBlocker::Middleware.allow_requests!
    end

    describe "#call" do
      let(:app) { double("Rack application") }

      before(:each) do
        allow(app).to receive(:call)
      end

      it "increments then decrements the active-request count" do
        request_count = double("atomic count")
        count = spy("count")
        allow(request_count).to receive(:update).and_yield(count)

        middleware = described_class.new(app,
                                         active_request_count: request_count)
        middleware.call({})

        expect(count).to have_received(:+).with(1)
        expect(count).to have_received(:-).with(1)
      end

      context "when requests are blocked" do
        before(:each) do
          RackRequestBlocker::Middleware.block_requests!
        end

        it "returns a 503 response" do
          middleware = described_class.new(app)
          expect(middleware.call({})).to eq([503, {}, []])
        end

        it "does not send app#call" do
          expect(app).to_not receive(:call)
        end
      end

      context "when requests are not blocked" do
        before(:each) do
          RackRequestBlocker::Middleware.allow_requests!
        end

        it "sends app#call" do
          middleware = described_class.new(app)
          expect(app).to receive(:call).with(foo: "bar")
          middleware.call({ foo: "bar" })
        end

        it "does not send app#call" do
          middleware = described_class.new(app)
          allow(app).to receive(:call).and_return([200, {}, %w[foo]])
          expect(middleware.call({})).to eq([200, {}, %w[foo]])
        end
      end
    end
  end
end
