require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:link_question) { create(:question, :with_gists_links, user: create(:user)) }
  let(:gist_question) { create(:question, :with_links, user: create(:user)) }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_values('http://foo.com', 'https://bar.com').for(:url) }
  it { should_not allow_value('a').for(:url).with_message("'a' is bad link.") }

  it "return gist's content" do
    expect(link_question.links.first.gist_content).to include('minute%2Cmonth%2Cyear%2Csecond')
  end

  it 'if simple link return null' do
    expect(gist_question.links.first.gist_content).to be_nil
  end
end
