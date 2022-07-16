require "rails_helper"
require "health/check"

describe Health::Check do
  describe ".health_checks" do
    it "stores the name of the health check under frequency" do
      expect(MockHealthCheck.health_checks[1.day]).to eq [:example]
    end

    it "stores multiple health checks with the same frequency" do
      expect(MockHealthCheck.health_checks[1.hour]).to eq [:another_example, :yet_another_example]
    end
  end
end