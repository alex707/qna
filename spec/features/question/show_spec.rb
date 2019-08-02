require 'rails_helper'

feature 'User can write answer for question on question page', %q{
  In order to write answer for community question
  As an authenticated user
  I'd like to be able to write answer on question page
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can write answer', js: true do
      fill_in 'Body', with: 'Test answer'

      click_on 'Write'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content('Your answer successfully created.')

      within '.answers' do
        expect(page).to have_content('Test answer')
      end
    end

    scenario 'User tries to write invalid answer', js: true do
      click_on 'Write'

      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question, user: create(:user)) }

    scenario 'User tries to write answer', js: true do
      visit question_path(question)

      expect(page).to_not have_link('Write')
    end
  end
end
