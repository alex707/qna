require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_values('http://foo.com', 'https://bar.com').for(:url) }
  it { should_not allow_value('a').for(:url).with_message("'a' is bad link.") }
end
