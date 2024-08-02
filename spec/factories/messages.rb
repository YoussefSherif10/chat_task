FactoryBot.define do
    factory :message do
      association :chat
      sequence(:number) { |n| n }
      content { "This is a test message" }
    end
end
  