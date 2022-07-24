module Health
  class ConfigurationError < StandardError; end

  module Configuration
    extend self

    def notifications_to
      if @notifications_to.nil? || @notifications_to == "change+me@example.com"
        raise Health::ConfigurationError.new("`notifications_to` misconfigured. Check config/initializers/health.rb")
      end

      @notifications_to
    end

    def notifications_to=(email)
      @notifications_to = email
    end
  end
end