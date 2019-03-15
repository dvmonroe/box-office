# frozen_string_literal: true

require "test_helper"

describe Box::Office::Showing do
  let(:showing) { Box::Office.showing(showings: 3, capacity: 500) }
  let(:members) { (1..1500).to_a }

  before { showing << members }

  after do
    showing.reserved.clear
    showing.standby.clear
  end

  describe "#reserve" do
    before do
      Box::Office.configure do |config|
        config.lock_reserved = false
      end
    end

    it "it correctly pops the first 500 values without duplication" do
      Box::Office::Booth.any_instance.stubs(:below_capacity?).returns(true)

      assert_difference "showing.standby.length", -500 do
        10.times.map { Thread.new { showing.reserve } }.each(&:join)
      end
binding.pry

      assert_equal 500, showing.reserved.length
      assert_equal (1..500).to_a.map(&:to_s).reverse, showing.reserved.members(limit: 500)
    end
  end
end
