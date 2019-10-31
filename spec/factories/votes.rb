FactoryBot.define do
  factory :vote do
    user
    voteable { create(:question) }
    value { 'like' }
  end
end
