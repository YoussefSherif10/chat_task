FactoryBot.define do
    factory :chat do
      association :application
      sequence(:number) { |n| n }
      application_id { 1 }
    end
end
  