shared_examples_for 'API show' do
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:entity_response) { json[entity.class.to_s.downcase] }

    before do
      do_request(method, api_path, params: { access_token: access_token.token },
                                   headers: headers)
    end

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'returns all public fields' do
      (entity.class.column_names - %w[user_id]).each do |attr|
        expect(entity_response[attr]).to eq entity.send(attr).as_json
      end
    end

    describe 'comments' do
      let(:comment) { entity.comments.first }
      let(:comment_response) { entity_response['comments'].first }

      it 'returns list of comments' do
        expect(entity_response['comments'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(comment_response[attr]).to eq comment.send(attr).as_json
        end
      end
    end

    describe 'files' do
      let(:file) { entity.files.first }
      let(:file_response) { entity_response['files'].first }

      it 'returns list of files' do
        expect(entity_response['files'].size).to eq 2
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
      let(:link) { entity.links[0] }
      let(:link_response) { entity_response['links'][0] }

      it 'returns list of links' do
        expect(entity_response['links'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          expect(link_response[attr]).to eq link.send(attr).as_json
        end
      end
    end
  end
end
