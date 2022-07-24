require "rails_helper"

describe Health do
  describe ".configure" do
    it "yields Health::Configuration" do
      described_class.configure do |configuration|
        expect(configuration.is_a?(Health::Configuration)).to be true
      end
    end
  end
end