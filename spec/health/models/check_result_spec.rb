require "rails_helper"

describe Health::CheckResult, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :resultable_type }
    it { is_expected.to validate_presence_of :resultable_id }
  end

  describe "relationships" do
    it { is_expected.to belong_to :health_check_run }
  end
end