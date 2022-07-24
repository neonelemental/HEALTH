require "health/version"
require "health/engine"

module Health
  autoload :Constants, "health/constants"
  autoload :Check, "health/check"
  autoload :Scheduler, "health/scheduler"
  autoload :ScheduleHelpers, "health/schedule_helpers"
  autoload :Configuration, "health/configuration"

  def self.configure
    yield Health::Configuration
  end
end
