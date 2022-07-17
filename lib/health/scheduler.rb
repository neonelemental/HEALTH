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

    def schedule_health_check?(health_check_class, health_check_method, frequency)
      last_ran_at = Health::CheckRecord.last_ran_at(health_check_class, health_check_method)

      last_ran_at.nil? ||
        last_ran_at + frequency < Time.zone.now
    end
  end
end