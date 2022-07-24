FactoryBot.define do
  factory :health_check_run, class: 'Health::CheckRun' do
    health_check_name { Health::CheckRun.to_health_check_name(MockHealthCheck, :example) }
    ran_at { Time.zone.now }
  end
end
