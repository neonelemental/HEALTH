require "rails_helper"
require "health/check"

describe Health::Check do
  describe ".health_checks" do
    class MockHealthCheck < Health::Check
    end

    it "defaults to an empty Hash" do
      expect(MockHealthCheck.health_checks).to be {}
    end
  end

  describe ".health_check" do
    class MockHealthCheck < Health::Check
      health_check :example, frequency: 1.day
    end

    it "stores the name of the health check under frequency" do
      expect(MockHealthCheck.health_checks[1.day]).to eq [:example]
    end

    it "stores multiple health checks with the same frequency" do
      MockHealthCheck.health_check(:another_example, frequency: 1.day)

      expect(MockHealthCheck.health_checks[1.day]).to eq [:example, :another_example]
    end
  end
end