module Health
  module Scheduler
    extend self

    def schedule
      if Rails.env.development?
        Rails.application.eager_load!
      end

      schedule = {}

      Health::Check.descendants.each do |health_check_class|
        health_check_class.health_checks.each do |frequency, health_check_methods|
          schedule[frequency] ||= []
          schedule[frequency] << [ health_check_class, health_check_methods]
        end
      end

      schedule
    end

    def schedule_health_check?(health_check_class, health_check_method, frequency_or_schedule)
      last_ran_at = Health::CheckRun.last_ran_at(health_check_class, health_check_method)

      if Health::ScheduleHelpers.is_frequency?(frequency_or_schedule)
        Health::ScheduleHelpers.should_run_using_frequency?(frequency_or_schedule, last_ran_at)
      else
        Health::ScheduleHelpers.should_run_using_schedule?(frequency_or_schedule, last_ran_at)
      end
    end
  end
end