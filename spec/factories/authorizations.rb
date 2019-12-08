FactoryBot.define do
  factory :authorization do
    user
    provider { 'MyProvider' }
    uid { 'SOME_UID' }
  end
end
