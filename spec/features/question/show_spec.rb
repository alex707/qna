require 'rails_helper'

feature 'User can write answer for question on question page', %q{
  In order to write answer for community question
  As an authenticated user
  I'd like to be able to write answer on question page
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }

    scenario 'User can write answer' do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'Test answer'

      click_on 'Write'

      expect(page).to have_content('Your answer successfully created.')
      expect(page).to have_content('Test answer')
    end

    scenario 'User tries to write invalid answer' do
      sign_in(user)
      visit question_path(question)

      click_on 'Write'

      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question, user: create(:user)) }

    scenario 'User tries to write answer' do
      visit question_path(question)
      fill_in 'Body', with: 'Test answer'

      click_on 'Write'

      expect(page).to have_content('You need to sign in or sign up before continuing')
    end
  end
end
