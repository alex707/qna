require 'rails_helper'

shared_examples 'comment action' do
  let(:user) { create(:user) }
  let(:entity_klass) { entity.class.to_s.downcase }

  context 'for authenticated user' do
    context 'with the correct body' do
      before { login(user) }

      it 'comment object' do
        comment_params = { id: entity.id, body: 'TestComment',
                           commentable: entity_klass }
        expect {
          post :create, params: { comment: comment_params }, format: :js
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:success)
      end

      it 'renders create' do
        comment_params = { id: entity.id, body: 'TestComment',
                           commentable: entity_klass }
        expect {
          post :create, params: { comment: comment_params }, format: :js
        }.to change(Comment, :count).by(1)

        expect(response).to render_template(:create)
      end
    end

    context 'with the uncorrect body' do
      before { login(user) }

      it 'tries to comment object' do
        comment_params = { id: entity.id, body: '',
                           commentable: entity_klass }
        expect {
          post :create, params: { comment: comment_params }, format: :js
        }.not_to change(Comment, :count)
      end

      it 'renders create' do
        comment_params = { id: entity.id, body: 'TestComment',
                           commentable: entity_klass }
        expect {
          post :create, params: { comment: comment_params }, format: :js
        }.to change(Comment, :count).by(1)

        expect(response).to render_template(:create)
      end
    end
  end

  context 'not authenticated user' do
    it 'tries to create comment' do
      comment_params = { id: entity.id, body: 'TestComment',
                         commentable: entity_klass }
      expect {
        post :create, params: { comment: comment_params }, format: :js
      }.not_to change(Comment, :count)

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to have_content('You need to sign in')
    end
  end
end
