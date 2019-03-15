# Box::Office

[![Build Status](https://travis-ci.org/dvmonroe/box-office.svg?branch=master)](https://travis-ci.org/dvmonroe/box-office)
[![Code Climate](https://codeclimate.com/github/dvmonroe/box-office/badges/gpa.svg)](https://codeclimate.com/github/dvmonroe/box-office)
[![Test Coverage](https://codeclimate.com/github/dvmonroe/box-office/badges/coverage.svg)](https://codeclimate.com/github/dvmonroe/box-office/coverage)

A queue worth lining up for.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'box-office'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install box-office

## Usage

Set up a new box office instance

This auto generates at least three seperate queue instances that
play a role in keeping the box office open

  1. Standby
  2. Reserved
  3. Fulfilled

You can override any of these names in the configuration

```ruby
showing = Box::Office.showing(name: "Jurassic Park", showings: 5)
```

Push values to the standby list

```ruby
showing.standby.push %w(Alan Ellie)
# OR
showing << %w(Alan Ellie)
```

Start popping values from standby into the reserved queue

```ruby
showing.reserve
```

With a block you can get the returned queue and the members

Utilizing the block will also take care of unlocking the queue to allow
future processes to utilize it.

```ruby
showing.reserve do |queue, members|
  # Do something with the queue and the members
end
```

When the show is over, just pop the members from the reserved queue.
If you've setup tracking of fulfilled, the member will be pushed to
the fulfilled queue.

```ruby
showing.fulfill(showing.reserved, %(Alan))
```

Access any queue instance in the box office
```ruby
showing.standby
showing.reserved
showing.fulfilled
```

### Queue

List all members

```ruby
showing.standby.members
```

Override the default limit of 100

```ruby
showing.standby.members(limit: 1_000)
```

Get length of the queue

```ruby
showing.standby.length
```

Empty the queue

```ruby
showing.standby.clear
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvmonroe/box-office. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Box::Office project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/box-office/blob/master/CODE_OF_CONDUCT.md).
