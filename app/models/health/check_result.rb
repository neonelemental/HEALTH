module Health
  class CheckResult < ApplicationRecord
    belongs_to :health_check_run, class_name: "Health::CheckRun"
    belongs_to :resultable, polymorphic: true

    validates :resultable_type,
              presence: true

    validates :resultable_id,
              presence: true
  end
end
