require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers, user: user) }

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
        expect { get :new, params: { question_id: question } }.to change(question.answers, :count).by(0)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'for an authenticated user' do
      before { sign_in(user) }

      context 'with valid attributes' do
        it 'assigns author to @answer.user' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }

          expect(assigns(:answer).user).to eq user
        end

        it 'saves new answer to database' do
          answer_params = { question_id: question, answer: attributes_for(:answer) }
          expect {
            post :create, params: answer_params
          }.to change(question.answers, :count).by(1)

          answer_params.merge answer_params.delete(:answer)
          created_answer = question.answers.find_by answer_params
          expect(created_answer).to be_present
        end

        it 'redirects to question view' do
          params = { question_id: question, answer: attributes_for(:answer) }
          post :create, params: params

          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not save answer' do
          question.reload

          expect {
            post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
          }.not_to change(Answer, :count)
        end

        it 're-renders show' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

          expect(response).to render_template 'questions/show'
        end
      end
    end

    context 'for an unatuhenticated user' do
      it 'tries to create answer' do
        expect {
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        }.to change(question.answers, :count).by(0)

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'for authenticated user' do
      it 'deletes the answer' do
        login(user)
        answer_id = question.answers.first.id

        expect { delete :destroy, params: { id: question.answers.first } }.to change(question.answers, :count).by(-1)
        expect(Answer.exists?(id: answer_id)).to eq false
      end

      it 'tries to delete answer of other user' do
        login(create(:user))

        expect { delete :destroy, params: { id: question.answers.first } }.to change(question.answers, :count).by(0)
      end

      it 'redirects to question' do
        login(user)

        delete :destroy, params: { id: question.answers.first }

        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'for unauthenticated user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: question.answers.first } }.to change(question.answers, :count).by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
