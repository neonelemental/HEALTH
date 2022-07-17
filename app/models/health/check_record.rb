module Health
  class CheckRecord < ApplicationRecord
    validates :ran_at, presence: true
    validates :health_check_name,
              presence: true,
              uniqueness: { scope: :ran_at }

    def self.last_ran_at(health_check_class, health_check_method)
      where(health_check_name: to_health_check_name(health_check_class, health_check_method)).
          order("created_at DESC").
          limit(1).
          first&.
          ran_at
    end

    def self.to_health_check_name(health_check_class, health_check_method)
      "#{health_check_class.to_s}##{health_check_method.to_s}"
    end
  end
end
