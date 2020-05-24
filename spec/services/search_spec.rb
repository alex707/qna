require 'sphinx_helper'

RSpec.describe Services::Search do
  subject { Services::Search }

  context 'calls .search for empty query' do
    let(:params) { Hash.new }

    it 'it nothing call', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        expect(ThinkingSphinx).to_not receive(:search)

        subject.new(params).call
      end
    end
  end

  context 'calls .search for all resources' do
    let(:params) { { query: 'test query' } }

    it 'it calling ThinkingSphinx', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        expect(ThinkingSphinx).to receive(:search).with('test query').and_call_original

        subject.new(params).call
      end
    end
  end

  context 'calls .search for each resources' do
    %w[question answer comment user].each do |resource|
      it "it calling resource #{resource.to_s}s", sphinx: true, js: true do
        ThinkingSphinx::Test.run do
          expect(resource.capitalize.constantize).to receive(:search).with("test #{resource.to_s.downcase}s").and_call_original

          subject.new({ query: "test #{resource.to_s}s", type: resource.to_s }).call
        end
      end
    end
  end

  context 'calls .search for wrong resource' do
    let(:params) { { query: 'test query', type: 'wrong' } }

    it 'it raise error', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        expect {
          subject.new(params).call
        }.to raise_error('Wrong type of resource')
      end
    end
  end
end
