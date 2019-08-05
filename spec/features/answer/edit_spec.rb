require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) do
    answer = create(:answer, question: question, user: user)
    answer.files.attach(
      io: File.open("#{Rails.root}/spec/factories/answers.rb"),
      filename: 'answers.rb'
    )
    answer
  end
  given(:other_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edit his answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'

        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('edited answer')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'edit his answer with errors', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'

        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content(answer.body)
      end
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'add attached files to answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'

        attach_file 'File', [
          "#{Rails.root}/spec/rails_helper.rb",
          "#{Rails.root}/spec/spec_helper.rb"
        ]

        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'answers.rb'
      end
    end

    scenario "tries to edit answer other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
