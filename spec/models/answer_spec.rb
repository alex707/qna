require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  describe 'checking current answer as favourite' do
    let(:user) { create(:user) }
    let(:question) { create(:question_with_answers, user: user) }

    it 'makes answer favourite' do
      answer = question.answers.first
      answer.favour
      answer.reload

      expect(answer.favourite).to eq true
    end

    it 'other answer of current question is favourite instead of old' do
      old_answer = question.answers.first
      old_answer.favour
      question.reload
      expect(old_answer).to be_favourite

      new_answer = question.answers.unfavourite.first
      new_answer.favour
      new_answer.reload
      question.reload
      expect(new_answer).to be_favourite

      old_answer.reload
      expect(old_answer).to_not be_favourite
    end
  end
end
