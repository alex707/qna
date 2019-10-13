require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'asks a question' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title question', with: 'Test question'
      fill_in 'Question body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with award' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title question', with: 'Test question'
      fill_in 'Question body', with: 'text text text'

      fill_in 'Award name', with: 'test award'

      attach_file 'Award image', Dir.glob("#{Rails.root}/*.jpg").first

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
      expect(page).to have_content 'test award'
    end

    scenario 'asks a question with errors' do
      visit questions_path
      click_on 'Ask question'

      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks the question with attached file' do
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title question', with: 'Test question'
      fill_in 'Question body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
