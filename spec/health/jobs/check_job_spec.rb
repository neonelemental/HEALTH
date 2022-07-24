require "rails_helper"

describe Health::CheckJob, active_job: true, type: :job do
  include ActiveJob::TestHelper

  let!(:mock_health_check) { MockHealthCheck }
  let!(:mock_instance) { mock_health_check.new }
  let(:mock_results) { [MockResult.create, MockResult.create] }

  class MockResult
    def id
      1
    end
  end

  subject(:health_check_job) do
    perform_enqueued_jobs do
      described_class.perform_later(mock_health_check, :example)
    end
  end

  before do
    allow(Health::CheckRun).to receive(:create!).and_return(true)
  end

  describe "#perform" do
    before do
      allow(mock_health_check).to receive(:new).and_return(mock_instance)
      allow(mock_instance).to receive(:example).and_return(mock_results)
    end

    it "creates a Health::CheckRun record" do
      expect { subject }.to change { Health::CheckRun.count }.by(1)
    end

    it "creates two Health::CheckResults record" do
      expect { subject }.to change { Health::CheckResult.count }.by(2)
    end
  end
end