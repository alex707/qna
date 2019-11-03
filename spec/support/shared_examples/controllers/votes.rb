require 'rails_helper'

shared_examples 'vote action' do
  let(:stranger) { create(:user) }
  let(:entity_klass) { entity.class.to_s.downcase }

  context 'for authenticated user' do
    context 'not owner' do
      before { login(stranger) }

      it 'like for object' do
        like_params = { id: entity.id, value: 'like', voteable: entity_klass }
        expect {
          post :vote, params: like_params, format: :json
        }.to change(entity.likes, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(response.body).to have_content('ok')
      end

      it 'like for object again' do
        like_params = { id: entity.id, value: 'like', voteable: entity_klass }
        expect {
          5.times { post :vote, params: like_params, format: :json }
        }.to change(entity.likes, :count).by(1)

        expect(response).to have_http_status(:success)
        expect(response.body).to have_content('ok')
      end

      it 'rollback like for object' do
        entity.vote!('like', stranger)

        vote_off_params = { id: entity.id, voteable: entity_klass }
        expect {
          post :vote, params: vote_off_params, format: :json
        }.to change(entity.likes, :count).by(-1)

        expect(response).to have_http_status(:success)
        expect(response.body).to have_content('ok')
      end

      it 'rollback like for object again' do
        entity.vote!('like', stranger)

        vote_off_params = { id: entity.id, voteable: entity_klass }
        expect {
          5.times { post :vote, params: vote_off_params, format: :json }
        }.to change(entity.likes, :count).by(-1)

        expect(response).to have_http_status(:success)
        expect(response.body).to have_content('ok')
      end
    end

    context 'owner' do
      before { login(entity.user) }

      it 'tries to like his object' do
        like_params = { id: entity.id, value: 'like', voteable: entity_klass }
        expect {
          post :vote, params: like_params, format: :json
        }.to change(entity.likes, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to have_content('error')
      end
    end
  end

  context 'not authenticated user' do
    it 'tries to like some object' do
      like_params = { id: entity.id, value: 'like', voteable: entity_klass }
      expect {
        post :vote, params: like_params, format: :json
      }.to change(entity.likes, :count).by(0)

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to have_content('error')
    end
  end
end
