shared_examples_for 'API create' do
  context 'authorized' do
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:entity_class) { Object.const_get(entity_class_name.to_s.capitalize) }

    context 'with valid attributes' do
      let(:entity_attributes) { attributes_for(entity_class_name, user: user.id) }
      let(:create_response) { json[entity_class_name.to_s] }

      before do
        do_request(method, api_path,
                   headers: headers,
                   params: { access_token: access_token.token,
                             entity_class_name => entity_attributes })
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id created_at updated_at].each do |attr|
          expect(create_response[attr].to_s).to_not be_empty
        end

        entity = entity_class.find(create_response['id'])

        pub_fields = ['body']
        pub_fields << 'title' if entity_class.column_names.include?('title')
        pub_fields.each do |attr|
          expect(create_response[attr]).to eq entity[attr.to_sym].as_json
          expect(create_response[attr]).to eq entity_attributes[attr.to_sym].as_json
        end
      end

      it 'contains user object' do
        entity = entity_class.find(create_response['id'])

        expect(create_response['user']['id']).to eq entity.user.id
        expect(create_response['user']['id']).to eq entity_attributes[:user]
      end

      it 'contains short title' do
        entity = entity_class.find(create_response['id'])

        if entity_class.column_names.include?('title')
          expect(create_response['short_title']).to eq entity_attributes[:title].truncate 7
          expect(create_response['short_title']).to eq entity.title.truncate 7
        end
      end
    end

    context 'with invalid attributes' do
      let(:entity_attributes) { attributes_for(entity_class_name, :invalid) }

      before do
        do_request(method, api_path,
                   headers: headers,
                   params: { access_token: access_token.token,
                             entity_class_name => entity_attributes })
      end

      it 'returns unprocessable_entity status' do
        expect(response.status).to eq 422
      end

      it 'returns errors list' do
        expect(json.keys).to be_any

        json.keys.each do |key|
          expect(key.to_sym.in?(entity_attributes.keys)).to be true
        end
      end
    end
  end
end
