require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should have_one(:gist_content).dependent(:destroy) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_values('http://foo.com', 'https://bar.com').for(:url) }
  it { should_not allow_value('a').for(:url).with_message("'a' is bad link.") }

  describe 'checking download gist content by link' do
    let(:user) { create(:user) }
    let(:gist_link) { create(:question, :with_gists_links, user: user).links.first }
    let(:simple_link) { create(:question, :with_links, user: user).links.first }

    before do
      stub_request(:get, /api.github.com/).to_return(
        status: 200,
        body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_1.json")
      )

      stub_request(:get, /ya.ru/).to_return(
        status: 200,
        body: '<html>some html<html>'
      )
    end

    it 'download gist content and saves to db by gist link' do
      expect {
        gist_link.download!
      }.to change(GistContent, :count).by(1)

      expect(gist_link.gist_content).to be_an_instance_of(GistContent)
      expect(gist_link.gist_content.content).to include('POST запрос')
    end

    it 'do not create gist content object by simple link' do
      expect {
        simple_link.download!
      }.to change(GistContent, :count).by(0)

      expect(simple_link.gist_content).to be_nil
    end
  end
end
