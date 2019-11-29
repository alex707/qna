require 'rails_helper'

feature 'User can see created comment of another user', %{
  In order to provide sending of created comment
  As an a user
  I'd like to be able to broadcast of the comment to other users
}, :js do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }
  given(:answer) { question.answers.second }

  context 'Multiply sessions' do
    context 'Only answer' do
      scenario "Comment for question appears on another user's question page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          expect(page).not_to have_content "Test cmmnt 4 #{question.id}"
        end

        Capybara.using_session('guest') do
          visit question_path(question)

          expect(page).not_to have_content "Test cmmnt 4 #{question.id}"
        end

        Capybara.using_session('user') do
          within ".new-question-#{question.id}-comment" do
            fill_in 'Comment body', with: "Test cmmnt 4 #{question.id}"

            click_on 'Add comment'
          end

          expect(page).to have_content "Test cmmnt 4 #{question.id}"
        end

        Capybara.using_session('guest') do
          expect(page).to have_content "Test cmmnt 4 #{question.id}"
        end
      end

      scenario "Comment for answer appears on another user's question page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)

          expect(page).not_to have_content "Test cmmnt 4 answ #{answer.id}"
        end

        Capybara.using_session('guest') do
          visit question_path(question)

          expect(page).not_to have_content "Test cmmnt 4 answ #{answer.id}"
        end

        Capybara.using_session('user') do
          within ".new-answer-#{answer.id}-comment" do
            fill_in 'Comment body', with: "Test cmmnt 4 answ #{answer.id}"

            click_on 'Add comment'
          end

          expect(page).to have_content "Test cmmnt 4 answ #{answer.id}"
        end

        Capybara.using_session('guest') do
          expect(page).to have_content "Test cmmnt 4 answ #{answer.id}"
        end
      end
    end
  end
end
