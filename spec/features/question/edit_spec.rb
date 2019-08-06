require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:question_with_files) do
    first_file = {
      io: File.open("#{Rails.root}/spec/factories/questions.rb"),
      filename: 'questions.rb'
    }
    second_file = {
      io: File.open("#{Rails.root}/spec/factories/users.rb"),
      filename: 'users.rb'
    }
    question.files.attach([first_file, second_file])
    question
  end

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    scenario 'edit his own question', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Title question', with: 'edited question'
        fill_in 'Question body', with: 'question body edit'
        click_on 'Save question'

        expect(page).to_not have_content(question.body)
        expect(page).to have_content('edited question')
        expect(page).to have_content('question body edit')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'edit his own answer with errors', js: true do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in 'Title question', with: ''
        fill_in 'Question body', with: ''
        click_on 'Save question'

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end
      expect(page).to have_content("Body can't be blank")
      expect(page).to have_content("Title can't be blank")
    end

    scenario 'add attached files to question', js: true do
      sign_in(user)
      visit question_path(question_with_files)

      click_on 'Edit question'

      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'questions.rb'
      end
    end

    scenario 'remove existing on question files', js: true do
      sign_in(user)
      visit question_path(question_with_files)

      click_on 'Edit question'

      within '.question' do
        click_on 'Remove file', match: :first

        expect(page).to_not have_link 'questions.rb'
        expect(page).to have_link 'users.rb'
      end
    end

    scenario "tries to edit other user's" do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
