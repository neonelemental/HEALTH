require "rails_helper"

describe Health::Configuration do
  subject { described_class.new }

  describe ".notifications_to=" do
    it "sets notifications_to configuration option" do
      subject.notifications_to = "test@example.com"

      expect(subject.notifications_to).to eq "test@example.com"
    end
  end

  describe ".notifications_to" do
    context "when @notifications_to is set" do
      it "returns the set value" do
        subject.notifications_to = "test@example.com"

        expect(subject.notifications_to).to eq "test@example.com"
      end
    end

    context "when @notifications_to is nil" do
      it "raises an error" do
        subject.notifications_to = nil

        expect { subject.notifications_to }.to raise_error(Health::ConfigurationError)
      end
    end

    context "when @notifications_to is set to default" do
      it "raises an error" do
        subject.notifications_to = "change+me@example.com"

        expect { subject.notifications_to }.to raise_error(Health::ConfigurationError)
      end
    end
  end
end