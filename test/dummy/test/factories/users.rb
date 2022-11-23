FactoryBot.define do
  factory :user do
    name { "First Last" }
    trait :with_long_name do
      name { "First Middle Last Jr" }
    end
  end
end
