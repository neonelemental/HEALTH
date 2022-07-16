require "rails_helper"

describe Health::CheckJob do
  let!(:mock_health_check) { MockHealthCheck }
  let!(:mock_instance) { mock_health_check.new }

  describe "#perform" do
    subject { described_class.perform_now(mock_health_check, :example) }

    before do
      allow(mock_health_check).to receive(:new).and_return(mock_instance)
      allow(mock_instance).to receive(:example)
      subject
    end

    it "instantiates a health_check_class and calls the health_check_method" do
      expect(mock_instance).to have_received(:example)
    end
  end
end