require "rails_helper"

describe Health::SchedulerJob, active_job: true, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_now }

  around do |example|
    Timecop.freeze(Time.zone.now.at_beginning_of_week) do
      example.run
    end
  end

  before do
    allow(Health::CheckJob).to receive(:perform_later)
    subject
  end

  it "schedules jobs health check jobs that need to be scheduled" do
    expect(Health::CheckJob).to have_received(:perform_later).exactly(4).times
  end
end