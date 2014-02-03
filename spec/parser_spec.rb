require 'spec_helper'

describe Alephant::Parser do

  let (:instance) { Alephant::Parser }
  subject { Alephant::Parser }

  describe "parse(msg)" do
    it "returns parsed JSON with symbolized keys" do
      data = "{ \"foo\":\"bar\" }"

      instance = subject.new.parse data
      key = instance.keys[0]

      key.should be_a Symbol
      instance[key].should eq 'bar'
    end
  end
end

