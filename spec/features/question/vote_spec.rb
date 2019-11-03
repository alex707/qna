require 'rails_helper'

feature 'User can vote for liked question', %{
  In order to vote for liked question
  As an authenticated user
  I'd like to be able to like
} do
  describe 'vote form for question' do
    it_behaves_like 'vote view' do
      given(:entity) { create(:question) }
      given(:visit_entity_path) { question_path(entity) }
    end
  end
end
