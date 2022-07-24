require "rails_helper"

describe Health::CheckJob, active_job: true, type: :job do
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  let!(:mock_health_check) { MockHealthCheck }
  let!(:mock_instance) { mock_health_check.new }
  let(:mock_results) { [MockResult.create, MockResult.create] }

  subject(:health_check_job) do
    described_class.perform_now(mock_health_check, :example)
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

    it "delivers an email" do
      expect { subject }.to change { ActiveJob::Base.queue_adapter.enqueued_jobs.size }.by(1)

      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.first["arguments"]).
          to include("Health::NotificationsMailer", "alert")
    end
  end
end