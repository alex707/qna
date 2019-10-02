require 'rails_helper'

RSpec.describe GistLoader do
  let(:gist_link) do
    'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb'
  end
  let(:gist_link_bad) do
    'https://gist.github.com/alex707/badlink'
  end
  subject { GistLoader.new(gist_link) }

  describe 'data recieved successfully' do
    before do
      stub_request(:get, /api.github.com/).to_return(
        status: 200,
        body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_1.json")
      )
    end

    it 'load and return gist content' do
      expect(subject.gist_content).to include('POST запрос')
    end
  end

  describe 'bad link format' do
    subject { GistLoader.new(gist_link_bad) }
    before do
      stub_request(:get, /api.github.com/).to_return(
        status: 404,
        body: '{"message": "Not Found"}'
      )
    end

    it 'try return gist content' do
      expect(subject.gist_content).to be_nil
    end
  end

  context 'connection problem' do
    describe 'when 500' do
      before do
        stub_request(:get, /api.github.com/)
          .to_return(status: [500, 'Internal Server Error'])
      end

      it 'gist content be nil' do
        expect(subject.gist_content).to be_nil
      end
    end

    describe 'when connection timeout' do
      before do
        stub_request(:get, /api.github.com/).to_timeout
      end

      it 'gist content be nil' do
        expect(subject.gist_content).to be_nil
      end
    end
  end
end
