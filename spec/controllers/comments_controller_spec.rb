require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'Answer test' do
    it_behaves_like 'comment action' do
      let(:entity) { create(:answer) }
    end
  end

  describe 'Question test' do
    it_behaves_like 'comment action' do
      let(:entity) { create(:question) }
    end
  end
end
