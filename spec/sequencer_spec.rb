require 'spec_helper'

describe Alephant::Sequencer do
  subject { Alephant::Sequencer }

  describe "sequential?(data)" do

    context "block_given? == true" do

      context "block is { herp }" do
        it "should fail" do
          fail
        end
      end

    end

    context "block_given? == false" do

      context "get_last_seen < data[:sequence_id]" do
        it "should fail" do
          fail
        end
      end

      context "get_last_seen >= data[:sequence_id]" do
        it "should fail" do
          fail
        end
      end

    end
  end
end

