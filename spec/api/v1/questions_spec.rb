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

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        get "/api/v1/questions/#{question.id}",
            params: { access_token: access_token.token },
            headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { question.comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id filename created_at].each do |attr|
            expect(file_response[attr]).to eq file.send(attr).as_json
          end

          helpers = Rails.application.routes.url_helpers
          expect(file_response['url']).to eq helpers.url_for(file).as_json
        end
      end

      describe 'links' do
        let(:link) { question.links[0] }
        let(:link_response) { question_response['links'][0] }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST api/v1/questions/' do
    let(:user) { create(:user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/questions/' }
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:question_attributes) { attributes_for(:question, user: user.id) }
        let(:create_response) { json['question'] }

        before do
          post '/api/v1/questions/',
               params: { access_token: access_token.token,
                         question: question_attributes },
               headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id created_at updated_at].each do |attr|
            expect(create_response[attr].to_s).to_not be_empty
          end

          question = Question.find(create_response['id'])

          %w[title body].each do |attr|
            expect(create_response[attr]).to eq question[attr.to_sym].as_json
            expect(create_response[attr]).to eq question_attributes[attr.to_sym].as_json
          end
        end

        it 'contains user object' do
          question = Question.find(create_response['id'])

          expect(create_response['user']['id']).to eq question.user.id
          expect(create_response['user']['id']).to eq question_attributes[:user]
        end

        it 'contains short title' do
          question = Question.find(create_response['id'])

          expect(create_response['short_title']).to eq question.title.truncate 7
          expect(create_response['short_title']).to eq question_attributes[:title].truncate 7
        end
      end

      context 'with invalid attributes' do
        let(:question_attributes) { attributes_for(:question, :invalid) }

        before do
          post '/api/v1/questions/',
               params: { access_token: access_token.token,
                         question: question_attributes },
               headers: headers
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors list' do
          expect(json.keys).to be_any

          json.keys.each do |key|
            expect(key.to_sym.in?(question_attributes.keys)).to be true
          end
        end
      end
    end
  end

  describe 'PATCH api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :patch }
    end

    context 'as owner of resource' do
      context 'with valid attributes' do
        let(:question_attributes) { attributes_for(:question, user: user) }
        let(:update_response) { json['question'] }

        before do
          patch "/api/v1/questions/#{question.id}",
                params: { access_token: access_token.token,
                          question: question_attributes },
                headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id created_at updated_at].each do |attr|
            expect(update_response[attr].to_s).to_not be_empty
          end

          question = Question.find(update_response['id'])

          %w[title body].each do |attr|
            expect(update_response[attr]).to eq question[attr.to_sym].as_json
            expect(update_response[attr]).to eq question_attributes[attr.to_sym].as_json
          end
        end

        it 'contains user object' do
          question = Question.find(update_response['id'])

          expect(update_response['user']['id']).to eq question.user.id
          expect(update_response['user']['id']).to eq question_attributes[:user].id
        end

        it 'contains short title' do
          question = Question.find(update_response['id'])

          expect(update_response['short_title']).to eq question.title.truncate 7
          expect(update_response['short_title']).to eq question_attributes[:title].truncate 7
        end
      end

      context 'with invalid attributes' do
        let(:question_attributes) { attributes_for(:question, :invalid) }

        before do
          patch "/api/v1/questions/#{question.id}",
                params: { access_token: access_token.token,
                          question: question_attributes },
                headers: headers
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors list' do
          expect(json.keys).to be_any

          json.keys.each do |key|
            expect(key.to_sym.in?(question_attributes.keys)).to be true
          end
        end
      end
    end

    context 'as not owner of resource' do
      let(:question2) { create(:question) }
      let(:question_attributes) { attributes_for(:question) }

      before do
        patch "/api/v1/questions/#{question2.id}",
              params: { access_token: access_token.token,
                        question: question_attributes },
              headers: headers
      end

      it 'returns 302 status' do
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:question) { create(:question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
      let(:method) { :delete }
    end

    context 'as owner of resource' do
      it 'returns 200 status' do
        expect {
          delete "/api/v1/questions/#{question.id}",
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Question, :count).by(-1)

        expect(response).to be_successful
      end
    end

    context 'as not owner of resource' do
      let!(:question2) { create(:question) }

      before do
        delete "/api/v1/questions/#{question2.id}",
               params: { access_token: access_token.token },
               headers: headers
      end

      it 'returns 302 status' do
        expect {
          delete "/api/v1/questions/#{question2.id}",
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Question, :count).by(0)

        expect(response.status).to eq 302
      end
    end
  end
end
