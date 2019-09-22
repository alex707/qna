require 'rails_helper'

feature 'User can add links to question', %{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb' }
  given(:url_ya) { 'https://ya.ru' }
  given(:bad_url) { 'foo@bar@123.ru' }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title question', with: 'Test question'
    fill_in 'Question body', with: 'Test text'
  end

  scenario 'User adds links when asks question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link for question'
    all '.nested-fields', count: 2

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist ya'
      fill_in 'Url', with: url_ya
    end

    click_on 'Ask'

    expect(page).to have_content('minute%2Cmonth%2Cyear%2Csecond')
    expect(page).to have_link 'My gist ya', href: url_ya
  end

  scenario 'User tries to add link with invalid url', js: true do
    fill_in 'Link name', with: 'My gist ya'
    fill_in 'Url', with: bad_url

    click_on 'Add link for question'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist ya'
      fill_in 'Url', with: bad_url + '_2'
    end

    click_on 'Ask'

    expect(page).to have_content "'#{bad_url}' is bad link."
    expect(page).to have_content "'#{bad_url + '_2'}' is bad link."
  end
end
