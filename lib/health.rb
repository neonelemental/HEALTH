require "health/version"
require "health/engine"

module Health
  autoload :Constants, "health/constants"
  autoload :Check, "health/check"
  autoload :Scheduler, "health/scheduler"
  autoload :ScheduleHelpers, "health/schedule_helpers"
end
