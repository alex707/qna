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

    it_behaves_like 'API show' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :get }
      let(:entity) { answer }
    end
  end

  describe 'POST api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
    end

    it_behaves_like 'API create' do
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
      let(:method) { :post }
      let(:entity_class_name) { :answer }
      let(:user) { create(:user) }
    end
  end

  describe 'PATCH api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
    end

    it_behaves_like 'API update' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :patch }
      let(:entity) { answer }
    end
  end

  describe 'DELETE api/v1/answers/:id' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like 'API Authorizable' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
    end

    it_behaves_like 'API delete' do
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
      let(:method) { :delete }
      let(:entity) { answer }
    end
  end
end
