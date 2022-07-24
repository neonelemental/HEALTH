require "health/version"
require "health/engine"

module Health
  autoload :Constants, "health/constants"
  autoload :Check, "health/check"
  autoload :Scheduler, "health/scheduler"
  autoload :ScheduleHelpers, "health/schedule_helpers"
  autoload :Configuration, "health/configuration"

  def self.configuration
    @@configuration ||= Health::Configuration.new
  end

  def self.configure
    yield configuration
  end
end
