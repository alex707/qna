require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end


  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    context 'for an authenticated user' do
      before { login(user) }

      it 'user assigns a new Question to @question' do
        get :new

        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'build new link for @question' do
        get :new

        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'for An Unauthenticated user' do
      it 'tries to assigns a new Question to @question' do
        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'GET #edit' do
    context 'For an authenticated user' do
      before { login(user) }

      it 'assigns the requested question to @question' do
        get :edit, params: { id: question }

        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        get :edit, params: { id: question }

        expect(response).to render_template(:edit)
      end
    end

    context 'for an unauthenticated user' do
      it 'tries to assign a new question to @question' do
        get :edit, params: { id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'POST #create' do
    context 'with valid attributes' do
      context 'for an authenticated user' do
        before { login(user) }

        it 'author assigns to @question.user' do
          attrs = attributes_for(:question)
          post :create, params: { question: attrs }

          expect(Question.exists?(attrs)).to eq true

          expect(assigns(:question).user).to eq user
        end

        it 'new question saves in database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question), user: user }

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        before { login(user) }

        it 'does not save question' do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'For an unauthenticated user' do
      it 'tries to save new question in database' do
        expect {
          post :create, params: { question: attributes_for(:question, :invalid) }
        }.to change(Question, :count).by(0)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end


  describe 'PATCH #update' do
    context 'for an authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new t', body: 'new b' } }, format: :js
          question.reload

          expect(question.title).to eq 'new t'
          expect(question.body).to eq 'new b'
        end

        it 'render template update' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'renders template update' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'for an unathenticated user' do
      it 'tries to assign the requested question to @question' do
        patch :update, params: { id: question, question: { title: 'new t', body: 'new b' } }, format: :js

        expect(question.title).to_not eq 'new t'
        expect(question.body).to_not eq 'new b'
      end
    end
  end


  describe 'DELETE #destroy' do
    context 'for an authenticated user' do
      let(:other_user) { create(:user) }
      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        login(user)
        attrs = { id: question.id }

        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)

        expect(Question.exists?(attrs)).to eq false
      end

      it 'tries to delete the question of other user' do
        login(other_user)

        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it 'redirects to index' do
        login(user)

        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'for an unauthenticated user' do
      it 'tries to delete the question' do
        question.reload
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
