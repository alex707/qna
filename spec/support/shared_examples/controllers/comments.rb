require 'rails_helper'

shared_examples 'comment action' do
  let(:stranger) { create(:user) }
  let(:entity_klass) { entity.class.to_s.downcase }

  context 'for authenticated user' do
    context 'not owner' do
      before { login(stranger) }

      it 'comment not his object' do
        comment_params = { id: entity.id, body: 'TestComment',
          commentable: entity_klass }
        expect {
          post :comment, params: comment_params, format: :json
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context 'owner' do
      before { login(entity.user) }

      it 'comment his object' do
        comment_params = { id: entity.id, body: 'TestComment',
          commentable: entity_klass }
        expect {
          post :comment, params: comment_params, format: :json
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'not authenticated user' do
    it 'tries to create comment' do
      comment_params = { id: entity.id, body: 'TestComment',
        commentable: entity_klass }
      expect {
        post :comment, params: comment_params, format: :json
      }.not_to change(Comment, :count)

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to have_content('error')
    end
  end
end
