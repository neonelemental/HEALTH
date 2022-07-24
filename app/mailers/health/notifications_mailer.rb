module Health
  class NotificationsMailer < ApplicationMailer
    default from: "healthchecks@upstart.com"

    def alert
      @health_check_run = params[:run]
      @health_check_results = params[:results]

      mail(
        to: Health.configuration.notifications_to,
        subject: "#{@health_check_run.health_check_name} failed!"
      )
    end
  end
end