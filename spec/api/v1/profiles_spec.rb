require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles/me' }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:me_response) { json['user'] }
      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token },
                                   headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(me_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:api_path) { '/api/v1/profiles' }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }

      before do
        get '/api/v1/profiles', params: { access_token: access_token.token },
                                headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of users profiles' do
        expect(json['users'].size).to eq 2
      end

      it 'current user is not exists in the list' do
        expect(json['users'].map { |user| user['id'] }).to_not include me.id
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end
      end
    end
  end
end
