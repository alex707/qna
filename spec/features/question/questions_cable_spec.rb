require 'rails_helper'

feature 'create question', :js do
  given(:user) { create(:user) }

  fcontext 'multiply sessions' do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        # page.find('#add_question_btn').trigger('click')
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
