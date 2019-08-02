require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  describe 'checking current answer as accepted' do
    let(:user) { create(:user) }
    let(:question) { create(:question_with_answers, user: user) }

    it 'makes answer accepted' do
      answer = question.answers.first
      answer.accept

      expect(question.accepted_id).to eq answer.id
    end

    it 'answer of current question accepted' do
      answer = question.answers.first
      answer.accept

      expect(answer).to be_accepted
    end

    it 'other answer of current question is not accepted' do
      question.answers.first.accept

      expect(question.answers.last).to_not be_accepted
    end
  end
end
