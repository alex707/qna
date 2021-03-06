require 'rails_helper'

feature 'User can delete his own answer', %q{
  In order to delete answers
  As an owner
  I'd like to be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question_with_own_answers, user: user) }

  scenario 'User can delete his own answer', js: true do
    sign_in(user)
    visit question_path(question)
    answer_id = question.answers.first.id

    find("a[data-answer-id='#{answer_id}']").click

    expect(page).to_not have_content body
  end

  scenario 'User can not delete answer of the other user' do
    sign_in(other_user)
    visit question_path(question)

    expect(page).to_not have_link('Delete Answer')
  end

  scenario 'An Unauthenticated User can not delete answer' do
    visit question_path(question)

    expect(page).to_not have_link('Delete Answer')
  end
end
