require "rails_helper"
require "health/scheduler"

describe Health::Scheduler do
  describe ".schedule" do
    it "returns a schedule" do
      expect(described_class.schedule).to eq({
                                               1.day => [[MockHealthCheck, [:example]]],
                                               1.hour => [[MockHealthCheck, [:another_example, :yet_another_example]]]
                                             })
    end
  end
end