FactoryBot.define do
  factory :vote do
    user
    voteable { question }
    value { 'none' }
  end
end
