require 'rails_helper'

feature 'User can add links to answer', %{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb' }
  given(:gist_url_ya) { 'https://ya.ru' }
  given(:bad_url) { 'foo@bar@123.ru' }

  before do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Test answer'
  end

  scenario 'User adds links when write answer', js: true do
    within 'form.new-answer' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'add link for answer'

      all '.nested-fields', count: 2

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My gist ya'
        fill_in 'Url', with: gist_url_ya
      end

      click_on 'Write'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist ya', href: gist_url_ya
    end
  end

  scenario 'User tries to add link with invalid url', js: true do
    within 'form.new-answer' do
      fill_in 'Link name', with: 'bad_url'
      fill_in 'Url', with: bad_url

      click_on 'Write'
    end

    within '.answer-errors' do
      expect(page).to have_content "'#{bad_url}' is bad link."
    end
  end
end
