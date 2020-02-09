FactoryBot.define do
  factory :link do
    name { "MyLink#{rand(99)}" }
    url { "http://my.site#{rand(99)}" }
    linkable { create(:question) }
  end
end
