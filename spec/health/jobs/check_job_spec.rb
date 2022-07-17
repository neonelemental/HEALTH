require "rails_helper"

describe Health::CheckJob, active_job: true, type: :job do
  include ActiveJob::TestHelper

  let!(:mock_health_check) { MockHealthCheck }
  let!(:mock_instance) { mock_health_check.new }

  subject(:health_check_job) do
    perform_enqueued_jobs do
      described_class.perform_later(mock_health_check, :example)
    end
  end

  before do
    allow(Health::CheckRecord).to receive(:create!).and_return(true)
  end

  describe "#perform" do
    before do
      allow(mock_health_check).to receive(:new).and_return(mock_instance)
      allow(mock_instance).to receive(:example)
      subject
    end

    it "instantiates a health_check_class and calls the health_check_method" do
      expect(mock_instance).to have_received(:example)
    end
  end

  describe "#after_perform" do
    before do
      subject
    end

    it "creates a new HealthCheck::Record" do
      expect(Health::CheckRecord).to have_received(:create!).
          with(hash_including({ health_check_name: "MockHealthCheck#example"}))
    end
  end
end