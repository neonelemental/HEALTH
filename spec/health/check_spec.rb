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

  describe ".validate_ops!" do
    subject(:validate_ops!) { described_class.validate_opts!(options) }

    context "when options[:frequency] is passed" do
      let(:options) { { frequency: frequency }}

      context "but the frequency is invalid" do
        let(:frequency) { "blah" }

        it "raises an error" do
          expect { subject }.to raise_error(Health::CheckError)
        end
      end

      context "and the frequency is valid" do
        let(:frequency) { 1.day }

        it "does not raise an error" do
          expect { subject }.not_to raise_error
        end
      end
    end

    context "when options[:scheduled] is passed" do
      let(:options) { { scheduled: scheduled } }

      context "but the schedule is not valid" do
        let(:scheduled) { :blahsdays }

        it "raises an error" do
          expect { subject }.to raise_error(Health::CheckError)
        end
      end

      context "and the schedule is valid" do
        let(:scheduled) { :mondays }

        it "does not raise an error" do
          expect { subject }.not_to raise_error
        end
      end
    end

    context "when options[:frequency] and options[:scheduled] are passed together" do
      let(:options) { { frequency: 1.day, scheduled: :mondays } }

      it "raises an error" do
        expect { subject }.to raise_error(Health::CheckError)
      end
    end
  end
end