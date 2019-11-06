require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #vote' do
    describe 'answer test' do
      it_behaves_like 'vote action' do
        let(:entity) { create(:answer) }
      end
    end

    describe 'question test' do
      it_behaves_like 'vote action' do
        let(:entity) { create(:question) }
      end
    end
  end
end
