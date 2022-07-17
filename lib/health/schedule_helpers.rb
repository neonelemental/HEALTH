module Health
  module ScheduleHelpers
    extend self

    def is_schedule?(frequency_or_schedule)
      Health::Constants::SCHEDULE_SYMBOLS.include?(frequency_or_schedule)
    end

    def is_weekday?(schedule_symbol)
      Health::Constants::WEEK_DAYS.keys.include?(schedule_symbol)
    end

    def is_frequency?(frequency_or_schedule)
      frequency_or_schedule.is_a?(ActiveSupport::Duration)
    end

    def should_run_using_schedule?(schedule_symbol, last_ran_at)
      if Health::ScheduleHelpers.is_weekday?(schedule_symbol)
        Health::ScheduleHelpers.should_run_weekday?(schedule_symbol, last_ran_at)
      end
    end

    def should_run_using_frequency?(frequency, last_ran_at)
      last_ran_at.nil? ||
        last_ran_at + frequency < Time.zone.now
    end

    def should_run_weekday?(weekday, last_ran_at)
      wday = Health::Constants::WEEK_DAYS.fetch(weekday)

      if last_ran_at.nil? && Time.zone.now.wday == wday
        true
      elsif last_ran_at.present? && ran_at_week_or_more_ago?(wday, last_ran_at)
        true
      else
        false
      end
    end

    private

    def ran_at_week_or_more_ago?(wday, last_ran_at)
      ( wday == Time.zone.now.wday &&
          last_ran_at.at_beginning_of_week < Time.zone.now.at_beginning_of_week ) ||
        # hasn't run for more than a week and should have
        (last_ran_at + 7.days).at_beginning_of_day < Time.zone.now.at_beginning_of_day
    end
  end
end