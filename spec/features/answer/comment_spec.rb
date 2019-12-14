require 'rails_helper'

feature 'User can comment answer', %{
  In order to comment for answer
  As an authenticated user
  I'd like to be able to fill form for answer's comment body
} do
  describe 'comment form for answer' do
    it_behaves_like 'comment view' do
      given(:question) { create(:question_with_answers, user: create(:user)) }
      given(:entity) { question.answers.last }
      given(:visit_entity_path) { question_path(question) }
    end
  end
end
