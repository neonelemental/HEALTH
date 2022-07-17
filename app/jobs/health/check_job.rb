module Health
  class CheckJob < Health::ApplicationJob
    def perform(health_check_class, health_check_method)
      Rails.logger.info(
        "Performing health check #{Health::CheckRecord.to_health_check_name(health_check_class, health_check_method)}"
      )

      health_check_class.new.send(health_check_method)
    end

    after_perform do |job|
      health_check_class = job.arguments.first
      health_check_method = job.arguments.second

      Health::CheckRecord.create!(
        health_check_name: Health::CheckRecord.to_health_check_name(health_check_class, health_check_method),
        ran_at: Time.zone.now
      )
    end
  end
end