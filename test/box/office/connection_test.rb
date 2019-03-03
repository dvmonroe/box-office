# frozen_string_literal: true

require "test_helper"

class TestConnectionClass
  include Box::Office::Connection
end

describe Box::Office::Connection do
  subject { TestConnectionClass.new }

  describe "#with_connection" do
    it "returns the configured instance in a block" do
      subject.with_connection do |conn|
        assert_instance_of Redis, conn
      end
    end
  end
end
