require "rails_helper"

describe Health::CheckRecord, type: :model do
  subject { Health::CheckRecord.new(health_check_name: "testerino", ran_at: Time.zone.now) }

  it { is_expected.to validate_presence_of :ran_at }
  it { is_expected.to validate_presence_of :health_check_name }
  it { is_expected.to validate_uniqueness_of(:health_check_name).scoped_to(:ran_at) }

  describe ".last_ran_at" do
    let!(:record1) { FactoryBot.create(:health_check_record, ran_at: Time.zone.yesterday) }
    let!(:record2) { FactoryBot.create(:health_check_record, ran_at: Time.zone.now) }

    it "returns the time of the last attempt to run a given health check" do
      expect(Health::CheckRecord.last_ran_at(MockHealthCheck, :example)).to eq(record2.ran_at)
    end
  end
end