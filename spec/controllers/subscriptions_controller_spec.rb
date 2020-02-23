require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:question2) { create(:question) }

  describe 'POST #subscribe' do
    context 'as authenticated user' do
      before { login(user) }

      it 'creates question subscription for user' do
        expect {
          post :subscribe, params: { question_id: question }, format: :js
        }.to change(user.subscriptions, :count).by(1)
      end

      it 'returns http success' do
        post :subscribe, params: { question_id: question.id }, format: :js
        expect(response).to have_http_status(:success)
      end

      it 'tries create subscribe twice' do
        expect {
          2.times do
            post :subscribe, params: { question_id: question }, format: :js
          end
        }.to change(user.subscriptions, :count).by(1)
      end
    end

    describe 'POST #unsubscribe' do
      context 'as authenticated user' do
        before { login(user) }
        before { question.subscribe!(user) }

        it 'removes question subscribe for user' do
          user.subscriptions.reload
          expect {
            post :unsubscribe, params: { question_id: question }, format: :js
          }.to change(user.subscriptions, :count).by(-1)
        end

        it 'returns http success' do
          post :unsubscribe, params: { question_id: question }, format: :js
          expect(response).to have_http_status(:success)
        end

        it 'tries remove subscribe twice from same question' do
          user.subscriptions.reload
          expect {
            2.times do
              post :unsubscribe, params: { question_id: question }, format: :js
            end
          }.to change(user.subscriptions, :count).by(-1)
        end

        it 'tries remove subscribe from another question' do
          expect {
            post :unsubscribe, params: { question_id: question2 }, format: :js
          }.to change(Subscription, :count).by(0)
        end
      end
    end
  end

  context 'as not authenticated user' do
    it 'tries to create subscription' do
      expect {
        post :subscribe, params: { question_id: question }, format: :js
      }.to change(Subscription, :count).by(0)
    end

    it 'tries to remove subscription' do
      expect {
        post :subscribe, params: { question_id: question }, format: :js
      }.to change(Subscription, :count).by(0)
    end
  end
end
