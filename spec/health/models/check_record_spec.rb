require "rails_helper"

describe Health::CheckRecord, type: :model do
  subject { Health::CheckRecord.new(health_check_name: "testerino", ran_at: Time.zone.now) }

  it { is_expected.to validate_presence_of :ran_at }
  it { is_expected.to validate_presence_of :health_check_name }
  it { is_expected.to validate_uniqueness_of(:health_check_name).scoped_to(:ran_at) }
end