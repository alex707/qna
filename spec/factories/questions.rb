FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    factory :question_with_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end
  end

  trait :invalid do
    title { nil }
  end
end
