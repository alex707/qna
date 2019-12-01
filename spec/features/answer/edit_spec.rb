require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, :with_files, question: question, user: user) }
  given(:other_user) { create(:user) }
  given(:answer_with_links) { create(:answer, :with_links, question: question, user: user) }

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
        expect(page).to_not have_selector('textarea#answer_body')
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

    scenario 'add link to existing links on answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        within all('.answer').last do
          click_on 'Edit'

          click_on 'Add link for answer'

          within all('.nested-fields').last do
            fill_in 'Link name', with: 'some_link'
            fill_in 'Url', with: 'https://some.com'
          end

          click_on 'Save'
        end
      end

      expect(page).to have_link 'some_link', href: 'https://some.com'
    end

    scenario 'remove existing link on answer', js: true do
      link1, link2 = answer_with_links.links[0..1]

      sign_in(user)
      visit question_path(question)

      within '.answers' do
        within all('.answer').last do
          click_on 'Edit'

          click_on 'Remove link', match: :first

          click_on 'Save', match: :first
        end
      end

      expect(page).to have_link link2.name, href: link2.url
      expect(page).to_not have_link link1.name, href: link1.url
    end

    scenario 'remove existing on answer files', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Remove file', match: :first

        expect(page).to_not have_link 'answers.rb'
        expect(page).to have_link 'users.rb'
      end
    end

    scenario "tries to edit answer other user's answer" do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
