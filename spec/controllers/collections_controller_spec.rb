require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  describe 'DELETE #remove_file' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, :with_files, user: user) }
    let!(:other_question) { create(:question, :with_files, user: other_user) }

    context 'An authenticated user' do
      before { login(user) }

      context 'As an owner' do
        it 'owner remove his file of his resource' do
          expect {
            delete :destroy, params: { id: question.files.first }, format: :js
          }.to change(ActiveStorage::Blob, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: question.files.first }, format: :js

          expect(response).to render_template(:destroy)
        end

        it 'show succesfull flash message' do
          delete :destroy, params: { id: question.files.first }, format: :js

          expect(flash['notice']).to have_content('files successfully removed')
        end
      end

      context 'As not owner of resource' do
        it 'tries to remove file' do
          expect {
            delete  :destroy,
                    params: { id: other_question.files.first },
                    format: :js
          }.to change(ActiveStorage::Blob, :count).by(0)
        end

        it 'show unsuccessfull flash message' do
          delete  :destroy,
                  params: { id: other_question.files.first },
                  format: :js
          expect(flash['alert']).to have_content('Only owner can remove files')
        end
      end
    end

    it 'As unauthenticated user tries to remove file' do
      expect {
        delete  :destroy,
                params: { id: question.files.first },
                format: :js
      }.to change(ActiveStorage::Blob, :count).by(0)

      expect(response).to have_http_status 401
      expect(response.body).to have_content('You need to sign in')
    end
  end
end
