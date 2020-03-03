require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_one(:award).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { accept_nested_attributes_for :award }

  describe Question do
    it_behaves_like 'linkable'
    it_behaves_like 'voteable'
    it_behaves_like 'commentable'
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'subscription on question' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    describe '#subscribe' do
      it 'user can subscribe to question' do
        expect {
          question.subscribe(user)
        }.to change(user.subscriptions, :count).by(1)
      end

      it 'user can not subscribe several times to one question' do
        expect {
          2.times { question.subscribe(user) }
        }.to change(question.subscriptions, :count).by(1)
      end
    end

    describe '#unsubscribe' do
      it 'user can unsubscribe from question' do
        question.subscribe(user)

        expect {
          question.unsubscribe(user)
        }.to change(question.subscriptions, :count).by(-1)
      end

      it 'user can not unsubscribe several times from one question' do
        question.subscribe(user)

        expect {
          2.times { question.unsubscribe(user) }
        }.to change(question.subscriptions, :count).by(-1)
      end
    end
  end
end
