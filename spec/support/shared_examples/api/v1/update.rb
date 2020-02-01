shared_examples_for 'API update' do
  let(:access_token) { create(:access_token, resource_owner_id: entity.user.id) }
  let(:entity_class_name) { entity.class.to_s.downcase.to_sym }
  let(:entity_class) { entity.class }

  context 'as owner of resource' do
    context 'with valid attributes' do
      let(:entity_attributes) { attributes_for(entity_class_name, user: entity.user) }
      let(:update_response) { json[entity_class_name.to_s] }

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
          expect(update_response[attr].to_s).to_not be_empty
        end

        updated_entity = entity_class.find(update_response['id'])

        pub_fields = ['body']
        pub_fields << 'title' if entity_class.column_names.include?('title')
        pub_fields.each do |attr|
          expect(update_response[attr]).to eq updated_entity[attr.to_sym].as_json
          expect(update_response[attr]).to eq entity_attributes[attr.to_sym].as_json
        end
      end

      it 'contains user object' do
        updated_entity = entity_class.find(update_response['id'])

        expect(update_response['user']['id']).to eq updated_entity.user.id
        expect(update_response['user']['id']).to eq entity_attributes[:user].id
      end

      it 'contains short title' do
        updated_entity = entity_class.find(update_response['id'])

        if entity_class.column_names.include?('title')
          expect(update_response['short_title']).to eq updated_entity.title.truncate 7
          expect(update_response['short_title']).to eq entity_attributes[:title].truncate 7
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

  context 'as not owner of resource' do
    let(:entity2) { create(entity_class_name) }
    let(:entity_attributes) { attributes_for(entity_class_name) }

    before do
      patch "/api/v1/#{entity_class_name.to_s.pluralize}/#{entity2.id}",
            params: { access_token: access_token.token,
                      entity_class_name => entity_attributes },
            headers: headers
    end

    it 'returns 302 status' do
      expect(response.status).to eq 302
    end
  end
end
