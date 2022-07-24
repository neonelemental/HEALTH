FactoryBot.define do
  factory :health_check_results, class: 'Health::CheckResult' do
    association :health_check_run
    ran_at { Time.zone.now }
  end
end
