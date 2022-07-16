module Health
  class CheckJob < Health::ApplicationJob
    def perform(health_check_class, health_check_method)
      health_check_class.new.send(health_check_method)
    end
  end
end