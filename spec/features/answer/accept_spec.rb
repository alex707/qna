require 'rails_helper'

feature 'User can accept answer as the best', %q{
  In order to accept the best answer
  As an author of question
  I'd like to be able to accept only one answer as the best answer for me
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  describe 'As an authenticated user' do
    describe 'as an author of the question' do
      scenario 'accept answer as the best', js: true do
        sign_in(user)
        visit question_path(question)

        click_on('Accept answer', match: :first)

        within '.accepted-answer' do
          expect(page).to have_content(question.answers.first.body)
        end

        within '.answers' do
          expect(page).to_not have_content(question.answers.first.body)
        end
      end
    end

    describe 'as not an author of question' do
      scenario 'tries accept answer as the best' do
        sign_in(create(:user))
        visit question_path(question)

        expect(page).to_not have_link('Accept answer')
      end
    end
  end

  scenario 'Unauthenticated user tries to accept answer' do
    visit question_path(question)

    expect(page).to_not have_link('Accept answer')
  end
end
