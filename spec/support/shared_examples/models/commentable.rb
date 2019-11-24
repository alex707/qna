require 'rails_helper'

shared_examples 'commentable' do
  context 'attributes availability' do
    it { should have_many(:comments).dependent(:destroy) }
  end

  context 'comment for entity' do
    let(:klass) { described_class.to_s.downcase.to_sym }
    let(:user) { create(:user) }
    let(:commentable_object) do
      described_class.create!(attributes_for(klass).merge(user: user))
    end

    describe 'Authenticated user' do
      it 'create comment with some body' do
        expect {
          commentable_object.comments.create!(body: 'Some Body', user: user)
        }.to change(Comment, :count).by(1)
        expect(commentable_object.comments.last.body).to eq 'Some Body'
      end
    end
  end
end
