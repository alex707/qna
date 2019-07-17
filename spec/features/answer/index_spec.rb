require 'rails_helper'

feature 'User can view list of answers for question', %q{
  In order to view answers of community
  As an user
  I'd like to be able to view all answers for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  scenario 'User can view answers for question' do
    visit question_path(question)

    question.answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
