# RackRequestBlocker

**NOTE**: Please see [this repo][1] if you're looking for the
`rack_request_blocker` gem.

Inserts a middleware at the top of the stack that stops further requests and
waits for in-flight requests to complete before proceeding. This is helpful for
Capybara full-stack tests where AJAX requests still in-flight interfere with
test tear-down. Based on ["Tearing Down Capybara Tests of AJAX Pages"][2] by
Joel Turkel at Salsify.

[1]: https://github.com/friendsoftheweb/rack_request_blocker
[2]: http://blog.salsify.com/engineering/tearing-capybara-ajax-tests

## Installation

Add these lines to your application's Gemfile:

```ruby
group :test do
  gem "rack_request_blocker"
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack_request_blocker

## Usage

Add the following line to your `spec_helper.rb` file:

```ruby
require "rack_request_blocker/rspec"
```

That's it.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack_request_blocker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
