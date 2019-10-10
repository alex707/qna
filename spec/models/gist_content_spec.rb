require 'rails_helper'

RSpec.describe GistContent, type: :model do
  it { should belong_to :link }

  it { should validate_presence_of(:content) }
end
