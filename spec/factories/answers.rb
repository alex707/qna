FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "MyText#{n.to_s.rjust(20, '0')}"
    end

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        answer.files.attach(
          [
            {
              io: File.open("#{Rails.root}/spec/factories/answers.rb"),
              filename: 'answers.rb'
            },
            {
              io: File.open("#{Rails.root}/spec/factories/users.rb"),
              filename: 'users.rb'
            }
          ]
        )
      end
    end

    trait :with_links do
      after :create do |answer|
        answer.links.create!(
          [
            {
              name: 'duckduckgo',
              url: 'https://www.duckduckgo.com'
            },
            {
              name: 'Wolfram|Alpha',
              url: 'https://www.wolframalpha.com/'
            }
          ]
        )
      end
    end
  end
end
