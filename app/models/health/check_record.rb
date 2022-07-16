module Health
  class CheckRecord < ApplicationRecord
    validates :ran_at, presence: true
    validates :health_check_name,
              presence: true,
              uniqueness: { scope: :ran_at }
  end
end
