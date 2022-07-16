module Health
  class CheckRecord < ApplicationRecord
    validates :ran_at, presence: true
  end
end
