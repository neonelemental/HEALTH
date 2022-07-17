require "rails_helper"
require "timecop"

describe Health::ScheduleHelpers do
  describe ".is_schedule?" do
    subject { described_class.is_schedule?(scheduled_symbol) }

    context "when symbol is in Health::Constants::SCHEDULE_SYMBOLS" do
      let(:scheduled_symbol) { Health::Constants::SCHEDULE_SYMBOLS.sample }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when symbol is not in Health::Constants::SCHEDULE_SYMBOLS" do
      let(:scheduled_symbol) { :blarghdays }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end

  describe ".is_weekday?" do
    subject { described_class.is_weekday?(scheduled_symbol) }

    context "when symbol is in Health::Constants::WEEK_DAYS.keys" do
      let(:scheduled_symbol) { Health::Constants::WEEK_DAYS.keys.sample }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when symbol is not in Health::Constants::WEEK_DAYS.keys" do
      let(:scheduled_symbol) { :blargh }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end

  describe ".is_frequency?" do
    subject { described_class.is_frequency?(frequency) }

    context "when frequency is an ActiveSupport::Duration" do
      let(:frequency) { 1.day }

      it "returns true" do
        expect(subject).to be true
      end
    end

    context "when frequency is not an ActiveSupport::Duration" do
      let(:frequency) { :blargh }

      it "returns false" do
        expect(subject).to be false
      end
    end
  end

  describe ".should_run_weekday?" do
    subject { described_class.should_run_weekday?(:mondays, last_ran_at) }

    around do |example|
      Timecop.freeze(Time.zone.now.at_beginning_of_week) do
        example.run
      end
    end

    context "when last_ran_at is nil" do
      let(:last_ran_at) { nil }

      it "returns true if the day is Sunday" do
        expect(subject).to be true
      end

      it "returns false if the day is not Sunday" do
        days_to_friday = (Time.zone.now.wday + 1) % 7 + 1
        friday = Time.zone.now - days_to_friday

        Timecop.travel(friday) do
          expect(subject).to be false
        end
      end
    end

    context "when last_ran_at is not nil" do
      context "and last_ran_at was last week" do
        # Around-or-about this time last week
        let(:last_ran_at) { Time.zone.now.at_beginning_of_week - 1.week + 45.minutes }

        it "returns true" do
          expect(subject).to be true
        end
      end

      context "and last_ran_at is less than a week ago and today is the day" do
        let(:last_ran_at) { Time.zone.now - 6.days }

        it "returns false" do
          expect(subject).to be true
        end
      end

      context "and last_ran_it is less than a week ago and today is not the day" do
        let(:last_ran_at) { Time.zone.now - 6.days }

        it "returns false" do
          Timecop.freeze(Time.zone.now.at_beginning_of_week+8.days)

          expect(subject).to be false
        end
      end
    end
  end
end