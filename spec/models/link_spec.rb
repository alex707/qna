require 'rails_helper'

RSpec.describe Link, type: :model do
  before do
    stub_request(:get, /api.github.com/).to_return(
      status: 200,
      body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_1.json")
    )
  end

  let(:gist_question) { create(:question, :with_gists_links, user: create(:user)) }
  let(:link_question) { create(:question, :with_links, user: create(:user)) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_values('http://foo.com', 'https://bar.com').for(:url) }
  it { should_not allow_value('a').for(:url).with_message("'a' is bad link.") }

  context 'gist link' do
    before do
      stub_request(:get, /api.github.com/).to_return(
        status: 200,
        body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_1.json")
      )
    end

    it "return gist's content" do
      expect(gist_question.links.first.gist_content).to include('minute%2Cmonth%2Cyear%2Csecond')
    end
  end

  context 'simple link' do
    before do
      stub_request(:get, /google.com/).to_return(
        status: 200, body: '<html>some html<html>'
      )

      stub_request(:get, /ya.ru/).to_return(
        status: 200, body: '<html>some html<html>'
      )
    end

    it 'if simple link return null' do
      expect(link_question.links.first.gist_content).to be_nil
    end
  end
end
