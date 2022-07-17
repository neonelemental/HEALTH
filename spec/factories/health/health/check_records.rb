FactoryBot.define do
  factory :health_check_record, class: 'Health::CheckRecord' do
    health_check_name { Health::CheckRecord.to_health_check_name(MockHealthCheck, :example) }
    ran_at { Time.zone.now }
  end
end
