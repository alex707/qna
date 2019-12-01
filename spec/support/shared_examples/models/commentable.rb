require 'rails_helper'

shared_examples 'commentable' do
  context 'attributes availability' do
    it { should have_many(:comments).dependent(:destroy) }
  end
end
