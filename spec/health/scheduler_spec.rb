require "rails_helper"
require "health/scheduler"

describe Health::Scheduler do
  describe ".schedule" do
    it "returns a schedule" do
      expect(described_class.schedule).to eq({
                                               1.day => [[MockHealthCheck, [:example]]],
                                               1.hour => [[MockHealthCheck, [:another_example, :yet_another_example]]],
                                               :mondays => [[MockHealthCheck, [:last_example]]],
                                             })
    end
  end

  describe ".schedule_health_check?" do
    subject(:schedule_health_check?) { described_class.schedule_health_check?(MockHealthCheck, :example, 1.day) }

    context "when a frequency is passed" do
      context "when the health check has not been run within its specified frequency" do
        let!(:record) { FactoryBot.create(:health_check_run, ran_at: Time.zone.now - 2.days) }

        it "returns true" do
          expect(schedule_health_check?).to be true
        end
      end

      context "when the health check has never been run" do
        it "returns true" do
          expect(Health::CheckRun.count).to be 0
          expect(schedule_health_check?).to be true
        end
      end

      context "when the health check has been run within its specified frequency" do
        let!(:record) { FactoryBot.create(:health_check_run, ran_at: Time.zone.now - 23.hours) }

        it "returns false" do
          expect(schedule_health_check?).to be false
        end
      end
    end

    context "when a schedule as been passed" do
      around do |example|
        Timecop.freeze(Time.zone.now.at_beginning_of_week) do
          example.run
        end
      end

      context "and the health check has been run on schedule" do
        let!(:record) { FactoryBot.create(:health_check_run, ran_at: Time.zone.now - 1.day) }

        it "returns false" do
          expect(schedule_health_check?).to be false
        end
      end

      context "and the health check has not been run on schedule" do
        let!(:record) { FactoryBot.create(:health_check_run, ran_at: Time.zone.now - 1.week) }

        it "returns true" do
          expect(schedule_health_check?).to be true
        end
      end
    end
  end
end