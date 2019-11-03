require 'rails_helper'

shared_examples 'voteable' do
  context 'attributes availability' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  context 'vote for entity' do
    let(:klass) { described_class.to_s.downcase.to_sym }
    let(:owner) { create(:user) }
    let(:stranger1) { create(:user) }
    let(:stranger2) { create(:user) }
    let(:voteable_object) do
      described_class.create!(attributes_for(klass).merge(user: owner))
    end

    describe 'votes by another user' do
      it 'not owner votes for voteable object' do
        voteable_object.vote!('like', stranger1)

        expect(voteable_object.likes.count).to eq 1
        expect(voteable_object.dislikes.count).to eq 0
      end

      it 'not owner takes his vote back' do
        voteable_object.vote!('like', stranger1)
        expect(voteable_object.likes.count).to eq 1

        voteable_object.vote!(nil, stranger1)
        expect(voteable_object.likes.count).to eq 0
      end

      it 'not owner votes several times' do
        expect {
          5.times { voteable_object.vote!('dislike', stranger1) }
        }.to change(Vote, :count).by(1)
      end

      it 'several users votes for voteable_object' do
        voteable_object.vote!('dislike', stranger1)
        voteable_object.vote!('dislike', stranger2)

        expect(voteable_object.likes.count).to eq 0
        expect(voteable_object.dislikes.count).to eq 2
      end
    end

    describe 'votes by owner' do
      it 'owner tries to vote for his voteable object' do
        expect {
          voteable_object.vote!('like', owner)
        }.to change(Vote, :count).by(0)
      end
    end
  end
end
