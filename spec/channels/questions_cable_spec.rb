require 'rails_helper'

feature 'User can see created question of another user', %{
  In order to provide sending of created question
  As an a user
  I'd like to be able to broadcast of the question to other users
}, :js do
  given(:user) { create(:user) }

  fcontext 'Multiply sessions' do
    scenario "Question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title question', with: 'Test question'
        fill_in 'Question body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
