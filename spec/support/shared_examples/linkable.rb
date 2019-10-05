require 'rails_helper'

shared_examples 'linkable' do
  context 'attributes availability' do
    it { should have_many(:links).dependent(:destroy) }
    it { accept_nested_attributes_for(:links) }
  end


  context 'link content' do
    context 'gist link' do
      let(:link) do
        described_class.new.links.build(
          name: 'snippet_1',
          url: 'https://gist.github.com/alex707/d6a7726c9132942cf755aa8e6fb52bfb'
        )
      end

      before do
        stub_request(:get, /api.github.com/).to_return(
          status: 200,
          body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_1.json")
        )
      end

      it "return gist's content" do
        expect(link.gist_content).to include('minute%2Cmonth%2Cyear%2Csecond')
      end
    end

    context 'simple link' do
      let(:link) do
        described_class.new.links.build(
          name: 'google',
          url: 'https://www.google.com'
        )
      end

      before do
        stub_request(:get, /google.com/).to_return(
          status: 200, body: '<html>some html<html>'
        )
      end

      it 'if simple link return null' do
        expect(link.gist_content).to be_nil
      end
    end
  end
end
