FactoryBot.define do
  factory :subscription do
    question { create(:question) }
    user { create(:user) }
  end
end
