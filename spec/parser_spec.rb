require 'spec_helper'

describe Alephant::Parser do
  describe "parse(msg)" do
    let(:msg) { Struct.new(:body).new("{ \"foo\":\"bar\" }") }
    let(:msg_with_options) do
      Struct.new(:body).new(<<-EOS)
          {
            "some" : {
              "location" : "bar"
            }
          }
      EOS
    end
    it "returns parsed JSON with symbolized keys" do
      subject.parse(msg)[:foo].should eq 'bar'
    end

    context "initialized with vary_jsonpath" do
      subject { Alephant::Parser.new('$.some.location') }

      it "adds the correct :options to the returned hash" do
        expect(subject.parse(msg_with_options)[:options][:variant]).to eq "bar"
      end
    end
  end
end

