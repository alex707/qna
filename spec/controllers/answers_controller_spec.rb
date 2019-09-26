require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question_with_answers, user: user) }
  let(:new_answer) { create(:answer, question: question, user: other_user) }
  let(:answer_with_links) { create(:answer, :with_links, question: question, user: user) }

  describe 'POST #favour' do
    context 'as an authenticated user' do
      before { sign_in(user) }

      context 'as an author' do
        it 'make the answer as favourite' do
          answer = question.answers.last
          post :favour, params: { id: answer }, format: :js
          answer.reload

          expect(answer).to be_favourite
          expect(answer.user.awards.first.name).to eq 'MyAward'
        end

        it 'make another the answer as favourite' do
          answer = question.answers.last
          answer.favour

          post :favour, params: { id: new_answer }, format: :js

          new_answer.reload
          answer.reload

          expect(new_answer).to be_favourite
          expect(answer).to_not eq be_favourite

          expect(new_answer.user.awards.first.name).to eq 'MyAward'
          expect(answer.user.awards.first).to be_nil
        end
      end

      context 'as not author' do
        it 'tries to make answer favourite' do
          answer = question.answers.first
          post :favour, params: { id: answer }, format: :js

          expect(answer).to_not be_favourite
        end
      end
    end

    context 'as unauthenticated user' do
      it 'tries to make answer favourite' do
        answer = question.answers.first
        post :favour, params: { id: answer }, format: :js

        expect(answer).to_not be_favourite
        expect(response).to have_http_status 401
        expect(response.body).to have_content('You need to sign in or sign up before continuing')
      end
    end
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

        it 'does not save answer with bad links' do
          answer_params = {
            question_id: question,
            answer: attributes_for(:answer).merge(
              links_attributes: {
                '0' => { name: 'b', url: 'b' }
              }
            )
          }
          expect {
            post :create, params: answer_params, format: :js
          }.to change(question.answers, :count).by(0)
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

          it 'remove answer link' do
            l = answer_with_links.links.first

            expect {
              patch :update, params: {
                id: answer_with_links,
                answer: {
                  body: 'new answer b',
                  links_attributes: {
                    '0' => { name: l.name, url: l.url, id: l.id, _destroy: '1' }
                  }
                }
              }, format: :js
            }.to change(Link, :count).by(-1)
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

          it 'does not change answer with bad links' do
            answer_params = {
              question_id: question,
              answer: { body: 'new answer body' }.merge(
                links_attributes: {
                  '0' => { name: 'b', url: 'b' }
                }
              )
            }
            expect {
              post :create, params: answer_params, format: :js
            }.to change(Link, :count).by(0)

            expect(answer.body).to_not eq 'new answer body'
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
