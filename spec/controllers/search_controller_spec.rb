require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let!(:question) { create(:question, title: 'test question') }
  let!(:question2) { create(:question, body: 'bad question') }
  let!(:answer) { create(:answer, body: 'test answer') }
  let!(:answer2) { create(:answer, body: 'bad answer') }
  let!(:comment) { create(:comment, body: 'test comment') }
  let!(:comment2) { create(:comment, body: 'bad comment') }
  let!(:user) { create(:user, email: 'test@test.test') }
  let!(:user2) { create(:user, email: 'bad@bad.bad') }

  describe 'GET #index' do
    context 'with empty query' do
      it 'it return empty search message', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index

          expect(assigns(:searched)).to be_nil
        end
      end

      it 'returns http success', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index

          expect(response).to have_http_status(:success)
        end
      end

      it 'render index view' do
        ThinkingSphinx::Test.run do
          get :index

          expect(response).to render_template(:index)
        end
      end
    end

    context 'when nothing found' do
      it 'it return empty search message', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'unreal' }

          expect(assigns(:searched)).to be_empty
        end
      end

      it 'returns http success', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'unreal' }

          expect(response).to have_http_status(:success)
        end
      end

      it 'render index view', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'unreal' }

          expect(response).to render_template(:index)
        end
      end
    end

    context 'global query search' do
      it 'return all types results', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'test' }

          %i[question answer comment user].each do |type|
            expect(assigns(:searched)).to include(send(type))
          end
        end
      end

      it 'return only valid result', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'test' }

          %i[question answer comment user].each do |type|
            expect(assigns(:searched)).to_not include(send("#{type}2"))
          end
        end
      end

      it 'returns http success', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'test' }

          expect(response).to have_http_status(:success)
        end
      end

      it 'render index view', sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          get :index, params: { query: 'test' }

          expect(response).to render_template(:index)
        end
      end
    end

    context 'search with specific type' do
      %i[question answer comment user].each do |type|
        it "return #{type}s which matching the query", sphinx: true, js: true do
          ThinkingSphinx::Test.run do
            query = type == :user ? user.email : 'test'
            get :index, params: { query: query, type: type }

            expect(assigns(:searched)).to include(send(type))
            expect(assigns(:searched)).to_not include(send("#{type}2"))
          end
        end

        it "return only #{type}s without other type", sphinx: true, js: true do
          ThinkingSphinx::Test.run do
            get :index, params: { query: 'test', type: type }

            (%i[question answer comment user] - [type]).each do |bad_type|
              expect(assigns(:searched)).to_not include(send(bad_type))
            end
          end
        end

        it 'returns http success', sphinx: true, js: true do
          ThinkingSphinx::Test.run do
            get :index, params: { query: 'test', type: type }

            expect(response).to have_http_status(:success)
          end
        end

        it 'render index view', sphinx: true, js: true do
          ThinkingSphinx::Test.run do
            get :index, params: { query: 'test', type: type }

            expect(response).to render_template(:index)
          end
        end
      end
    end
  end
end
