require "rails_helper"

describe Health::CheckRecord, type: :model do
  it { is_expected.to validate_presence_of :ran_at }
end