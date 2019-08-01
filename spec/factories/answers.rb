FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "MyText#{n.to_s.rjust(20, '0')}"
    end

    trait :invalid do
      body { nil }
    end
  end
end
