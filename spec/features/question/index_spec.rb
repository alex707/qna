require 'rails_helper'

feature 'User can view list of questions', %q{
  In order to asked for community questions
  As an authenticated user
  I'd like to be able to list of questions
} do
  given!(:questions) { create_list(:question, 3, user: create(:user)) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'can view list of questions' do
      sign_in(user)

      visit questions_path

      questions.each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can view list of questions' do
      visit questions_path

      questions.each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end
    end
  end
end
