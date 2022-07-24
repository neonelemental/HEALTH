require "rails_helper"

describe Health::Configuration do
  describe ".notifications_to=" do
    it "sets notifications_to configuration option" do
      described_class.notifications_to = "test@example.com"

      expect(described_class.notifications_to).to eq "test@example.com"
    end
  end

  describe ".notifications_to" do
    subject { described_class.notifications_to }

    context "when @notifications_to is set" do
      it "returns the set value" do
        described_class.notifications_to = "test@example.com"

        expect(subject).to eq "test@example.com"
      end
    end

    context "when @notifications_to is set to default" do
      it "raises an error" do
        described_class.notifications_to = "change+me@example.com"

        expect { subject }.to raise_error(Health::ConfigurationError)
      end
    end

    context "when @notifications_to is nil" do
      it "raises an error" do
        described_class.notifications_to = nil

        expect { subject }.to raise_error(Health::ConfigurationError)
      end
    end
  end
end