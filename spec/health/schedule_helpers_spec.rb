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
    subject { described_class.send(:should_run_weekday?,:mondays, last_ran_at) }

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

  describe ".should_run_using_schedule?" do
    subject { described_class.should_run_using_schedule?(schedule, last_ran_at) }

    before do
      Timecop.travel(time)
    end

    let(:time) { Time.zone.now } # sane default

    context "and the schedule symbol is not recognized" do
      let(:schedule) { :blahsdays }
      let(:last_ran_at) { Time.zone.now }

      it { is_expected.to be false }
    end

    context "when schedule is :beginning_of_month" do
      let(:schedule) { :beginning_of_month }

      context "and last_ran_at is nil" do
        let(:last_ran_at) { nil }

        context "and it's the beginning of the month" do
          let(:time) { Time.zone.now.at_beginning_of_month }

          it { is_expected.to be true }
        end

        context "and it's not the beginning of the month" do
          let(:time) { Time.zone.now.at_beginning_of_month + 3.days }

          it { is_expected.to be false }
        end
      end

      context "and last_ran_at is this month" do
        let(:last_ran_at) { Time.zone.now.beginning_of_month }

        context "and it's the beginning of the month" do
          let(:time) { Time.zone.now.at_beginning_of_week }

          it { is_expected.to be false }
        end

        context "and it's not the beginning of the month" do
          let(:time) { Time.zone.now.at_beginning_of_month + 1.week }

          it { is_expected.to be false }
        end
      end

      context "and last_ran_at is last month" do
        let(:last_ran_at) { 1.month.ago.beginning_of_month }

        context "and it's the beginning of the week" do
          let(:time) { Time.zone.now.at_beginning_of_month }

          it { is_expected.to be true }
        end

        context "and it's not the beginning of the week" do
          let(:time) { Time.zone.now.at_beginning_of_week + 1.days }

          it { is_expected.to be true }
        end
      end
    end

    context "when schedule is :end_of_month" do
      let(:schedule) { :end_of_month }

      context "and last_ran_at is nil" do
        let(:last_ran_at) { nil }

        context "and it's the end of the month" do
          let(:time) { Time.zone.now.at_beginning_of_month - 3.weeks }

          it { is_expected.to be false }
        end

        context "and it's not the end of the month" do
          let(:time) { Time.zone.now.at_end_of_month.at_beginning_of_day + 1.hour }

          it { is_expected.to be true }
        end
      end

      context "and last_ran_at is this month" do
        let(:last_ran_at) { Time.zone.now.end_of_month.at_beginning_of_day }

        context "and it's the end of the month" do
          let(:time) { Time.zone.now.at_end_of_month }

          it { is_expected.to be false }
        end

        context "and it's not the end of the month" do
          let(:time) { Time.zone.now.at_end_of_month - 1.week }

          it { is_expected.to be false }
        end
      end

      context "and last_ran_at is last month" do
        context "and it's the end of the month" do
          let(:last_ran_at) { (Time.zone.now - 32.days).at_end_of_month }
          let(:time) { Time.zone.now.at_end_of_month }

          it { is_expected.to be true }
        end

        context "and it's not the end of the month" do
          let(:last_ran_at) { (Time.zone.now - 32.days - 1.week).at_end_of_month }
          let(:time) { Time.zone.now.at_end_of_month + 1.week }

          it { is_expected.to be true }
        end
      end
    end
  end
end