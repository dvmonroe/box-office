# frozen_string_literal: true

require "test_helper"

describe Box::Office::Configuration do
  let(:klass) { Box::Office::Configuration }
  subject { Box::Office::Configuration.new }

  it { assert_instance_of Redis, subject.instance }
end
