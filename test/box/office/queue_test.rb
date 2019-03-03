# frozen_string_literal: true

require "test_helper"

describe Box::Office::Queue do
  subject { Box::Office::Queue.new("juarassic-park:standby") }

  after do
    subject.clear
  end

  describe "#name" do
    it { assert_equal "juarassic-park:standby", subject.name }
  end

  describe "#push" do
    context "it can push multiple members at once" do
      context "it returns length added" do
        it { assert_equal 2, subject.push(%w(Alan Ellie)) }
      end
    end

    context "it can handle a single string" do
      context "it returns length added" do
        it { assert_equal 1, subject.push("Ian") }
      end
    end

    context "<< works" do
      context "it returns length added" do
        it { assert_equal 1, subject << "Ian" }
      end
    end
  end

  describe "#empty" do
    it { assert subject.empty? }

    context "not empty" do
      before { subject.push("Ian") }
      it { refute subject.empty? }
    end
  end

  describe "#length" do
    before { subject.push("Ian") }
    it { assert_equal 1, subject.length }
  end

  describe "#members" do
    before { subject.push(%w(Ian Alan Ellie)) }
    it { assert_equal %w(Ian Alan Ellie).reverse, subject.members }

    context "with limit arg" do
      it "returns based on limit" do
        assert_equal %w(Ellie Alan), subject.members(limit: 2)
      end
    end
  end

  describe "#clear" do
    before { subject.push(%w(Ian Alan Ellie)) }

    it "clears all members" do
      assert_difference "subject.length", -3 do
        subject.clear
      end
    end
  end

  describe "#remove" do
    before { subject.push(%w(Ian Ian)) }
    it "removes all values equal to the arg" do
      assert_difference "subject.length", -2 do
        assert subject.remove("Ian")
      end
    end
  end
end
