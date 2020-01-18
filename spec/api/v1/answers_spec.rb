require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_files) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before do
        get "/api/v1/answers/#{answer.id}",
            params: { access_token: access_token.token },
            headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { answer.comments.first }
        let(:comment_response) { answer_response['comments'].first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_response) { answer_response['files'].first }

        it 'returns list of files' do
          expect(answer_response['files'].size).to eq 2
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
        let(:link) { answer.links[0] }
        let(:link_response) { answer_response['links'][0] }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:answer_attributes) { attributes_for(:answer, user: user.id) }
        let(:create_response) { json['answer'] }

        before do
          post "/api/v1/questions/#{question.id}/answers",
               params: { access_token: access_token.token,
                         answer: answer_attributes },
               headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id created_at updated_at].each do |attr|
            expect(create_response[attr].to_s).to_not be_empty
          end

          answer = Answer.find(create_response['id'])

          %w[body].each do |attr|
            expect(create_response[attr]).to eq answer[attr.to_sym].as_json
            expect(create_response[attr]).to eq answer_attributes[attr.to_sym].as_json
          end
        end

        it 'contains user object' do
          answer = Answer.find(create_response['id'])

          expect(create_response['user']['id']).to eq answer.user.id
          expect(create_response['user']['id']).to eq answer_attributes[:user]
        end
      end

      context 'with invalid attributes' do
        let(:answer_attributes) { attributes_for(:answer, :invalid) }

        before do
          post "/api/v1/questions/#{question.id}/answers",
               params: { access_token: access_token.token,
                         answer: answer_attributes },
               headers: headers
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors list' do
          expect(json.keys).to be_any

          json.keys.each do |key|
            expect(key.to_sym.in?(answer_attributes.keys)).to be true
          end
        end
      end
    end
  end

  describe 'PATCH api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
    end

    context 'as owner of resource' do
      context 'with valid attributes' do
        let(:answer_attributes) { attributes_for(:answer, user: user) }
        let(:update_response) { json['answer'] }

        before do
          patch "/api/v1/answers/#{answer.id}",
                params: { access_token: access_token.token,
                          answer: answer_attributes },
                headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns all public fields' do
          %w[id created_at updated_at].each do |attr|
            expect(update_response[attr].to_s).to_not be_empty
          end

          answer = Answer.find(update_response['id'])

          %w[body].each do |attr|
            expect(update_response[attr]).to eq answer[attr.to_sym].as_json
            expect(update_response[attr]).to eq answer_attributes[attr.to_sym].as_json
          end
        end

        it 'contains user object' do
          answer = Answer.find(update_response['id'])

          expect(update_response['user']['id']).to eq answer.user.id
          expect(update_response['user']['id']).to eq answer_attributes[:user].id
        end
      end

      context 'with invalid attributes' do
        let(:answer_attributes) { attributes_for(:answer, :invalid) }

        before do
          patch "/api/v1/answers/#{answer.id}",
                params: { access_token: access_token.token,
                          answer: answer_attributes },
                headers: headers
        end

        it 'returns unprocessable_entity status' do
          expect(response.status).to eq 422
        end

        it 'returns errors list' do
          expect(json.keys).to be_any

          json.keys.each do |key|
            expect(key.to_sym.in?(answer_attributes.keys)).to be true
          end
        end
      end
    end

    context 'as not owner of resource' do
      let(:answer2) { create(:answer) }
      let(:answer_attributes) { attributes_for(:answer) }

      before do
        patch "/api/v1/answers/#{answer2.id}",
              params: { access_token: access_token.token,
                        answer: answer_attributes },
              headers: headers
      end

      it 'returns 302 status' do
        expect(response.status).to eq 302
      end
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:answer) { create(:answer, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
    end

    context 'as owner of resource' do
      it 'returns 200 status' do
        expect {
          delete "/api/v1/answers/#{answer.id}",
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Answer, :count).by(-1)

        expect(response).to be_successful
      end
    end

    context 'as not owner of resource' do
      let!(:answer2) { create(:answer) }

      before do
        delete "/api/v1/answers/#{answer2.id}",
               params: { access_token: access_token.token },
               headers: headers
      end

      it 'returns 302 status' do
        expect {
          delete "/api/v1/answers/#{answer2.id}",
                 params: { access_token: access_token.token },
                 headers: headers
        }.to change(Answer, :count).by(0)

        expect(response.status).to eq 302
      end
    end
  end
end
