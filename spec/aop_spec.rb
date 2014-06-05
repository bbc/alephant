require 'spec_helper'

describe Alephant::AOP do
  describe "#around(fn_name)" do
    it "Overwrites the existing method with the block passed in, providing hooks for before and after the original method call" do

      states = []

      Test.around('test_method') do |state, args|
        states << state
        if state == :before
          args.should eq(['test'])
        elsif state == :after
          args.should eq(['test', 'test_return'])
        end
      end

      Test.new.test_method('test')
      states.should include(:before, :after)

    end
  end
end

