module Health
  class CheckError < StandardError; end

  class Check
    def self.health_checks
      @health_checks ||= {}
    end

    def self.health_check(name, opts = {})
      validate_opts!(opts)

      key = opts[:frequency] || opts.fetch(:scheduled)

      health_checks[key] ||= []
      health_checks[key] << name
    end

    def self.validate_opts!(opts)
      if opts[:frequency] && opts[:scheduled]
        raise Health::CheckError.
            new(":frequency specified with :scheduled option.  Pick one or the other.")
      elsif opts[:scheduled] && !Health::ScheduleHelpers.is_schedule?(opts[:scheduled])
        raise Health::CheckError.
            new("Unknown schedule symbol.  Valid symbols are\n#{Health::Constants::SCHEDULE_SYMBOLS}")
      elsif opts[:frequency] && !Health::ScheduleHelpers.is_frequency?(opts[:frequency])
        raise Health::CheckError.
          new(":frequency must be an ActiveSupport::Duration, like `1.day`.")
      end
    end
  end
end