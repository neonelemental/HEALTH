require "health/version"
require "health/engine"

module Health
  autoload :Check, "health/check"
  autoload :Scheduler, "health/scheduler"
end
