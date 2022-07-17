module Health
  class SchedulerJob < ApplicationJob
    def perform
      Health::Scheduler.schedule.each do |frequency, health_checks|
        health_checks.each do |health_check_class, health_check_methods|
          health_check_methods.each do |health_check_method|
            if Health::Scheduler.schedule_health_check?(health_check_class, health_check_method, frequency)
              Health::CheckJob.perform_later(health_check_class, health_check_method)
            end
          end
        end
      end
    end
  end
end