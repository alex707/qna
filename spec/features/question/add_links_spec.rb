require 'rails_helper'

feature 'User can add links to question', %{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb' }
  given(:gist_url_ya) { 'https://ya.ru' }

  before do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test text'
  end

  scenario 'User adds links when asks question', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link for question'
    all '.nested-fields', count: 2

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'My gist ya'
      fill_in 'Url', with: gist_url_ya
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'My gist ya', href: gist_url_ya
  end
end
