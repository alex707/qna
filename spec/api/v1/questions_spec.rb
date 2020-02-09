require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token },
                                 headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate 7
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id' do
    let!(:question) { create(:question, :with_files) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
    end

    it_behaves_like 'API show' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :get }
      let(:entity) { question }
    end
  end

  describe 'POST api/v1/questions/' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions/' }
      let(:method) { :post }
    end

    it_behaves_like 'API create' do
      let(:api_path) { '/api/v1/questions/' }
      let(:method) { :post }
      let(:entity_class_name) { :question }
      let(:user) { create(:user) }
    end
  end

  describe 'PATCH api/v1/questions/:id' do
    let(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
    end

    it_behaves_like 'API update' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
      let(:entity) { question }
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
    end

    it_behaves_like 'API delete' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
      let(:entity) { question }
    end
  end
end
