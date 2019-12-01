FactoryBot.define do
  factory :comment do
    body { 'MyText' }
    commentable { create(:question) }
    user
  end
end
