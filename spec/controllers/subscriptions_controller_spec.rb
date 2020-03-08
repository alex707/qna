require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:question2) { create(:question) }

  describe 'POST #create' do
    context 'as authenticated user' do
      before { login(user) }

      context 'without subscription' do
        it 'creates question subscription for user' do
          expect {
            post :create, params: { question_id: question }, format: :js
          }.to change(user.subscriptions, :count).by(1)
        end

        it 'returns http success' do
          post :create, params: { question_id: question.id }, format: :js
          expect(response).to have_http_status(:success)

          user.reload
          expect(
            JSON.parse(response.body)['id']
          ).to eq user.subscriptions.find_by(question: question).id

          expect(JSON.parse(response.body)['result']).to eq 'subscribe'
        end
      end
    end

    context 'as non authenticated' do
      it 'tries to create subscription' do
        expect {
          post :create, params: { question_id: question }, format: :js
        }.not_to change(Subscription, :count)
        expect(response.body).to have_content('You need to sign')
      end

      it 'returns unauth status' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to have_content('You need to sign in')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'as authenticated user' do
      before { login(user) }
      before { question.subscribe(user) }

      context 'with subscription' do
        it 'removes question subscribe' do
          user.subscriptions.reload
          expect {
            delete :destroy, params: { id: user.subscriptions.find_by(question: question) }, format: :js
          }.to change(user.subscriptions, :count).by(-1)
        end

        it 'returns http success' do
          subscription_id = user.subscriptions.find_by(question: question).id
          params = { id: subscription_id, format: :js }
          delete :destroy, params: params, format: :js

          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['id']).to eq subscription_id

          expect(JSON.parse(response.body)['result']).to eq 'unsubscribe'
        end
      end

      context 'without subscription' do
        it 'tries remove subscribe from another question' do
          params = { id: user.subscriptions.find_by(question: question2),
                     format: :js }
          expect(delete: :destroy, params: params).not_to be_routable
        end
      end
    end

    context 'as not authenticated user' do
      it 'tries to remove subscription' do
        params = { id: user.subscriptions.find_by(question: question),
                   format: :js }
        expect(delete: :destroy, params: params).not_to be_routable
      end
    end
  end
end
