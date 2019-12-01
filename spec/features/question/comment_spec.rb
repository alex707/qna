require 'rails_helper'

feature 'User can comment question', %{
  In order to comment for question
  As an authenticated user
  I'd like to be able to fill form for question's comment body
} do
  describe 'comment form for question' do
    it_behaves_like 'comment view' do
      given(:entity) { create(:question) }
      given(:visit_entity_path) { question_path(entity) }
    end
  end
end
