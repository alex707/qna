FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'http://my.site' }
    linkable { create(:question) }
  end
end
