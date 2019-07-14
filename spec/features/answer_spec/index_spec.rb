require 'rails_helper'

feature 'User can view list of answers for question', %q{
  In order to view answers of community
  As an user
  I'd like to be able to view all answers for question
} do
  scenario 'User can view answers for question' do
    question = create(:question_with_answers)

    visit question_path(question)

    expect(page).to have_css('.answer', count: 3)
  end
end
