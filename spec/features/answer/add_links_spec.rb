require 'rails_helper'

feature 'User can add links to answer', %{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/alex707/71d5c90e5cf72dc9765a2eebc2bfb416' }
  given(:url_ya) { 'https://ya.ru' }
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

      click_on 'Add link for answer'

      all '.nested-fields', count: 2

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My url ya'
        fill_in 'Url', with: url_ya
      end

      click_on 'Write'
    end

    sleep 5

    within '.answers' do
      expect(page).to have_content('get-запрос на главную')
      expect(page).to have_link 'My url ya', href: url_ya
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
