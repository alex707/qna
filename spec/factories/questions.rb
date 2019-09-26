FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    factory :question_with_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |question, evaluator|
        question.create_award!(name: 'MyAward')
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end
  end

  trait :invalid do
    title { nil }
  end

  trait :with_files do
    after :create do |question|
      question.files.attach(
        [
          {
            io: File.open("#{Rails.root}/spec/factories/questions.rb"),
            filename: 'questions.rb'
          },
          {
            io: File.open("#{Rails.root}/spec/factories/users.rb"),
            filename: 'users.rb'
          }
        ]
      )
    end
  end

  trait :with_gists_links do
    after :create do |question|
      question.links.create!(
        [
          {
            name: 'snippet_1',
            url: 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb'
          }
        ]
      )
    end
  end

  trait :with_links do
    after :create do |question|
      question.links.create!(
        [
          {
            name: 'google',
            url: 'https://www.google.com'
          },
          {
            name: 'ya',
            url: 'http://ya.ru'
          }
        ]
      )
    end
  end
end
