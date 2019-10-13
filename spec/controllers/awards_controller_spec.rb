require 'rails_helper'

RSpec.describe AwardsController, type: :controller do
  let(:user) { create(:user) }
  let(:new_user) { create(:user) }
  let(:question1) { create(:question_with_answers, user: user) }
  let(:question2) { create(:question_with_answers, user: user) }
  let(:answer1) { create(:answer, question: question1, user: new_user) }
  let(:answer2) { create(:answer, question: question2, user: new_user) }

  before do
    answer1.favour
    answer2.favour
  end

  describe 'GET #index' do
    context 'as an authenticated user' do
      before { sign_in(new_user) }
      before { get :index }

      it "populates an array of all user's award" do
        expect(assigns(:awards)).to match_array([question1.award, question2.award])
      end

      it 'render index view' do
        expect(response).to render_template(:index)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'as unauthenticated user' do
      it 'tries to watch awards' do
        get :index

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
