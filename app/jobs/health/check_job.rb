module Health
  class CheckJob < Health::ApplicationJob
    def perform(health_check_class, health_check_method)
      Rails.logger.info(
        "Performing health check #{Health::CheckRun.to_health_check_name(health_check_class, health_check_method)}"
      )

      results = health_check_class.new.send(health_check_method)
      run = Health::CheckRun.new(
        health_check_name: Health::CheckRun.to_health_check_name(health_check_class, health_check_method),
        ran_at: Time.zone.now
      )
      run.save!
      run.reload

      results.each do |result|
        Health::CheckResult.create!(
          resultable_type: result.class.to_s,
          resultable_id: result.id,
          health_check_run: run,
        )
      end

      Health::NotificationsMailer.with(
        run: run,
        results: results,
      ).alert.deliver_later
    end
  end
end