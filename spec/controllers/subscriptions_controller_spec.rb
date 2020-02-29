require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:question2) { create(:question) }

  describe 'POST #create' do
    context 'as authenticated user' do
      before { login(user) }

      it 'creates question subscription for user' do
        expect {
          post :create, params: { question_id: question }, format: :js
        }.to change(user.subscriptions, :count).by(1)
      end

      it 'returns http success' do
        post :create, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(:success)
      end
    end

    describe 'DELETE #destroy' do
      context 'as authenticated user' do
        before { login(user) }
        before { question.subscribe!(user) }

        it 'removes question subscribe for user' do
          user.subscriptions.reload
          expect {
            delete :destroy, params: { question_id: question }, format: :js
          }.to change(user.subscriptions, :count).by(-1)
        end

        it 'returns http success' do
          delete :destroy, params: { question_id: question }, format: :js
          expect(response).to have_http_status(:success)
        end

        it 'tries remove subscribe from another question' do
          expect {
            delete :destroy, params: { question_id: question2 }, format: :js
          }.to change(Subscription, :count).by(0)
        end
      end
    end
  end

  context 'for guest' do
    it 'tries to create subscription' do
      expect {
        post :create, params: { question_id: question }, format: :js
      }.to change(Subscription, :count).by(0)
    end

    it 'tries to remove subscription' do
      expect {
        delete :destroy, params: { question_id: question }, format: :js
      }.to change(Subscription, :count).by(0)
    end
  end
end
