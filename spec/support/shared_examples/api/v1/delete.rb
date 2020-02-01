shared_examples_for 'API delete' do
  let(:access_token) { create(:access_token, resource_owner_id: entity.user.id) }
  let(:entity_class) { entity.class }
  let(:entity_class_name) { entity.class.to_s.downcase.to_sym }

  context 'as owner of resource' do
    it 'returns 200 status' do
      expect {
        do_request(method, api_path, params: { access_token: access_token.token },
                                     headers: headers)
      }.to change(entity_class, :count).by(-1)

      expect(response).to be_successful
    end
  end

  context 'as not owner of resource' do
    let!(:entity2) { create(entity_class_name) }

    it 'returns 302 status' do
      expect {
        delete "/api/v1/#{entity_class_name.to_s.pluralize}/#{entity2.id}",
               params: { access_token: access_token.token },
               headers: headers
      }.to change(entity_class, :count).by(0)

      expect(response.status).to eq 302
    end
  end
end
