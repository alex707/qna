require 'rails_helper'

feature 'User can add links to answer', %{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb' }

  scenario 'User adds link when write answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Test answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Write'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
