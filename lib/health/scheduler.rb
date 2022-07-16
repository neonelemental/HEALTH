module Health
  module Scheduler
    extend self

    def schedule
      schedule = {}

      Health::Check.descendants.each do |health_check_class|
        health_check_class.health_checks.each do |frequency, health_check_methods|
          schedule[frequency] ||= []
          schedule[frequency] << [ health_check_class, health_check_methods]
        end
      end

      schedule
    end
  end
end