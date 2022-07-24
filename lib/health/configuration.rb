module Health
  class ConfigurationError < StandardError; end

  class Configuration
    attr_writer :notifications_to

    def notifications_to
      if @notifications_to.nil? || @notifications_to == "change+me@example.com"
        raise Health::ConfigurationError.new("`notifications_to` misconfigured. Check config/initializers/health.rb")
      end

      @notifications_to
    end
  end
end