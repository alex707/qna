require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { sign_in(user) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves new answer to database' do
        params = { question_id: question, answer: attributes_for(:answer), user: user }
        expect { post :create, params: params }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        params = { question_id: question, answer: attributes_for(:answer), user: user }
        post :create, params: params
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        params = { question_id: question, answer: attributes_for(:answer, :invalid), user: user }
        expect { post :create, params: params }.to_not change(Answer, :count)
      end

      it 're-renders show' do
        params = { question_id: question, answer: attributes_for(:answer, :invalid), user: user }
        post :create, params: params
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
