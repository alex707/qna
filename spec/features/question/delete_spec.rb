require 'rails_helper'

feature 'User can delete his own question', %q{
  In order to delete questions
  As an owner of question
  I'd like to be able to delete my question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User can delete his own question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted'
  end

  scenario 'User can not delete question of the other user' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link('Delete', href: question_path(question))
  end

  scenario 'An Unauthenticated user can not delete the question' do
    visit question_path(question)

    expect(page).to_not have_link('Delete', href: question_path(question))
  end
end
