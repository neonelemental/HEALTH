module Health
  class Check
    def self.health_checks
      @health_checks ||= {}
    end

    def self.health_check(name, frequency:)
      health_checks[frequency] ||= []
      health_checks[frequency] << name
    end
  end
end