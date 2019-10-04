FactoryBot.define do
  factory :award do
    name { 'MyString' }
    association :question

    after(:build) do |award|
      award.image.attach(
        io: File.open(Dir.glob("#{Rails.root}/*.jpg").first),
        filename: 'award.jpg'
      )
    end
  end
end
