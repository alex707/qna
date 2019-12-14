require 'rails_helper'

feature 'User can vote for liked answer', %{
  In order to vote for liked answer
  As an authenticated user
  I'd like to be able to like
} do
  describe 'vote form for answer' do
    it_behaves_like 'vote view' do
      given(:question) { create(:question_with_answers, user: create(:user)) }
      given(:entity) { question.answers.last }
      given(:visit_entity_path) { question_path(question) }
    end
  end
end
