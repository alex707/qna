FactoryBot.define do
  factory :question do
    title { "MyString#{rand(99)}" }
    body { "MyText#{rand(99)}" }
    user { create(:user) }

    factory :question_with_own_answers do
      after(:create) do |question, _evaluator|
        question.create_award!(name: "MyAward_#{question.id}")
        question.award.image.attach(
          io: File.open(Dir.glob("#{Rails.root}/*.jpg").first),
          filename: 'award.jpg'
        )
        create_list(:answer, 2, question: question, user: question.user)
      end
    end

    factory :question_with_answers do
      after(:create) do |question, _evaluator|
        create_list(:answer, 2, question: question, user: create(:user))
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

  trait :with_comments do
    after :create do |question|
      question.comments.create!(
        [
          {
            body: 'comment_1',
            user: create(:user)
          },
          {
            body: 'comment_2',
            user: create(:user)
          }
        ]
      )
    end
  end
end
