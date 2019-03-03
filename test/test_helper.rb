# frozen_string_literal: true

require "bundler/setup"

require "minitest/autorun"
require "minitest/spec"
require "minitest/reporters"
require "mocha/minitest"
require "pry"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "box/office"

require "active_support/testing/assertions"

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

module Kernel
  alias context describe
end

class MiniTest::Spec
  include ActiveSupport::Testing::Assertions

  before do
    redis_config = { host: "localhost", port: 6379, db: 1, pool_size: 5 }

    Box::Office.configure do |config|
      config.instance = Redis.new(redis_config)
    end
  end
end
