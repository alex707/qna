require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers, user: user) }

  describe 'POST #accept' do
    context 'as an authenticated user' do
      context 'as an author' do
        it 'accept the answer as the best' do
          answer = question.answers.last
          post :accept, params: { id: answer }, format: :js

          expect(answer).to be_accepted
        end
      end

      # context 'as not author' do
      #   it 'tries accept the answer as the best'
      # end
    end

    # context 'as unauthenticated user' do
    #   it 'tries accept the answer as the best'
    # end
  end

  describe 'GET #new' do
    context 'as an authenticated user' do
      before { sign_in(user) }

      it 'assigns a new Answer to @answer' do
        get :new, params: { question_id: question }

        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'renders new view' do
        get :new, params: { question_id: question }

        expect(response).to render_template(:new)
      end
    end

    context 'as an unauthenticated user' do
      it 'assigns a new answer to @answer' do
        expect {
          get :new, params: { question_id: question }
        }.to change(question.answers, :count).by(0)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'for an authenticated user' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'assigns author to @answer.user' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

          expect(assigns(:answer).user).to eq user
        end

        it 'saves new answer to database' do
          answer_params = { question_id: question, answer: attributes_for(:answer) }
          expect {
            post :create, params: answer_params, format: :js
          }.to change(question.answers, :count).by(1)

          answer_params.merge answer_params.delete(:answer)
          created_answer = question.answers.find_by answer_params
          expect(created_answer).to be_present
        end

        it 'renders create template' do
          params = { question_id: question, answer: attributes_for(:answer), format: :js }
          post :create, params: params

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer' do
          question.reload

          expect {
            post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
          }.not_to change(Answer, :count)
        end

        it 'renders create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }

          expect(response).to render_template :create
        end
      end
    end

    context 'for an unatuhenticated user' do
      it 'tries to create answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        }.to change(question.answers, :count).by(0)

        expect(response).to have_http_status 401
        expect(response.body).to have_content('You need to sign in or sign up before continuing')
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'for authenticated user' do
      context 'tries to edit his answer' do
        context 'with valid attributes' do
          before { sign_in(user) }

          it 'changes answer attributes' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { sign_in(user) }

          it 'does not change answer attributes' do
            expect {
              patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            }.to_not change(answer, :body)
          end

          it 'renders update view' do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
            expect(response).to render_template :update
          end
        end
      end

      context 'tries to edit answer of other user' do
        before { sign_in(create(:user)) }

        it 'does not change answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      it 'deletes the answer' do
        login(user)
        answer_id = question.answers.first.id

        expect {
          delete :destroy, params: { id: question.answers.first }, format: :js
        }.to change(question.answers, :count).by(-1)

        expect(Answer.exists?(id: answer_id)).to eq false
      end

      it 'tries to delete answer of other user' do
        login(create(:user))

        expect {
          delete :destroy, params: { id: question.answers.first }, format: :js
        }.to change(question.answers, :count).by(0)
      end

      it 'renders template destroy' do
        login(user)

        delete :destroy, params: { id: question.answers.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'for unauthenticated user' do
      it 'tries to delete answer' do
        expect {
          delete :destroy, params: { id: question.answers.first }, format: :js
        }.to change(question.answers, :count).by(0)

        expect(response).to have_http_status 401
      end
    end
  end
end
