require 'rails_helper'

RSpec.describe GistContent, type: :model do
  it { should belong_to :link }
end
