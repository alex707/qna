require 'rails_helper'

feature 'User can pick up favourite answer', %q{
  In order to pick up the best answer
  As an author of question
  I'd like to be able to pick up only one answer as the best answer for me
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  describe 'As an authenticated user' do
    describe 'as an author of the question' do
      background { sign_in(user) }

      scenario 'make answer favourite', js: true do
        visit question_path(question)
        click_on('Favourite answer', match: :first)
        question.reload

        answers = question.answers

        within '.answers' do
          answers.count.times do |i|
            within all('.answer')[i] do
              # test order of answers
              # first answer must be favourite

              if i.zero?
                expect(page).to have_content answers[0].body
              else
                expect(page).to have_content answers[i].body
              end

              expect(page).to have_content(answers[i].body).once
            end
          end
        end
      end

      scenario 'favour another answer as the best', js: true do
        visit question_path(question)
        click_on('Favourite answer', match: :first)
        question.reload

        answers = question.answers
        old_answer = answers.first
        new_answer = answers.second

        within '.favourite' do
          expect(page).to have_content old_answer.body
        end

        within '.answers' do
          click_on('Favourite answer', match: :first)
          question.reload
          answers = question.answers

          expect(page).to have_content(old_answer.body)

          within all('.answer')[0] do
            expect(page).to have_content new_answer.body
            expect(page).to_not have_content(old_answer.body)
          end

          expect(page).to have_content(old_answer.body).once
          expect(page).to have_content(new_answer.body).once
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
