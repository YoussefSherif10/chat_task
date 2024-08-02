FactoryBot.define do
    factory :application do
      name { "Test Application" }
      sequence(:token) { |n| "AppToken-#{n}" } 
    end
end
  