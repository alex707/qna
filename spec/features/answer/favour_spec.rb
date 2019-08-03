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
      background { sign_in(user) }

      scenario 'make answer favourite', js: true do
        visit question_path(question)

        click_on('Favourite answer', match: :first)

        within '.favourite-answer' do
          expect(page).to have_content(question.answers.first.body)
        end

        within '.answers' do
          expect(page).to_not have_content(question.answers.first.body)
        end
      end

      scenario 'favour another answer as the best', js: true do
        answers = question.answers.unfavourite
        new_answer = answers.second
        old_answer = answers.first

        old_answer.favour
        old_answer.reload

        visit question_path(question)

        within '.answers' do
          click_on('Favourite answer', match: :first)

          expect(page).to have_content(old_answer.body)
          expect(page).to_not have_content(new_answer.body)
        end

        within '.favourite-answer' do
          expect(page).to have_content(new_answer.body)
        end
      end
    end

    describe 'as not an author of question' do
      scenario 'tries to make favourite answer' do
        sign_in(create(:user))
        visit question_path(question)

        expect(page).to_not have_link('Favourite answer')
      end
    end
  end

  scenario 'Unauthenticated user tries to to make favourite answer' do
    visit question_path(question)

    expect(page).to_not have_link('Favourite answer')
  end
end
