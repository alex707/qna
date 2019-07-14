require 'rails_helper'

feature 'User can delete his own answer', %q{
  In order to delete answers
  As an owner
  I'd like to be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user) }

  scenario 'User can delete his own answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete Answer', match: :first

    expect(page).to have_content 'Answer successfully deleted'
  end

  scenario 'User can not delete answer of the other user' do
    sign_in(other_user)
    visit question_path(question)

    click_on 'Delete Answer', match: :first

    expect(page).to have_content 'Only owner can delete his answer'
  end
end
