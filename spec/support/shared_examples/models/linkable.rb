require 'rails_helper'

shared_examples 'linkable' do
  context 'attributes availability' do
    it { should have_many(:links).dependent(:destroy) }
    it { accept_nested_attributes_for(:links) }
  end
end
