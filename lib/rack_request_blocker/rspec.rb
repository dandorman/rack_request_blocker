RSpec.configure do |config|
  config.after(:example, type: :feature) do
    RackRequestBlocker::Waiter.new(page).wait
  end
end
