require 'rails_helper'

RSpec.describe Vote, type: :controller do
  controller ApplicationController do
    include Voted
  end

  before do
    routes.draw { put :vote, to: 'anonymous#vote' }
  end

  let!(:owner) { create(:user) }
  let!(:stranger) { create(:user) }
  let(:answer) { create(:answer, user: owner) }

  describe 'POST #vote' do
    context 'for authenticated user' do
      context 'not owner' do
        before { login(stranger) }

        it 'like for object' do
          like_params = { id: answer.id, value: 'like', voteable: 'answer' }
          expect {
            post :vote, params: like_params, format: :json
          }.to change(answer.likes, :count).by(1)

          expect(response).to have_http_status(:success)
          expect(response.body).to have_content('ok')
        end

        it 'rollback like for object' do
          answer.vote!('like', stranger)

          none_params = { id: answer.id, value: 'none', voteable: 'answer' }
          expect {
            post :vote, params: none_params, format: :json
          }.to change(answer.likes, :count).by(-1)

          expect(response).to have_http_status(:success)
          expect(response.body).to have_content('ok')
        end
      end

      context 'owner' do
        before { login(owner) }

        it 'tries to like his object' do
          like_params = { id: answer.id, value: 'like', voteable: 'answer' }
          expect {
            post :vote, params: like_params, format: :json
          }.to change(answer.likes, :count).by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to have_content('error')
        end
      end
    end

    context 'not authenticated user' do
      it 'tries to like some object' do
        like_params = { id: answer.id, value: 'like', voteable: 'answer' }
        expect {
          post :vote, params: like_params, format: :json
        }.to change(answer.likes, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to have_content('error')
      end
    end
  end
end
