require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  it { accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'checking current answer as favourite' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question_with_answers, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:new_answer) { create(:answer, question: question, user: other_user) }

    it 'makes answer favourite' do
      answer.favour
      expect(answer).to be_favourite
    end

    it 'give award for user of favorite answer' do
      answer.favour
      expect(answer.user.awards.first.name).to eq "MyAward_#{answer.question.id}"
    end

    it 'other answer of current question is favourite instead of old' do
      answer.favour
      new_answer.favour
      answer.reload
      expect(answer).to_not be_favourite
      expect(new_answer).to be_favourite
    end

    it 'give award for user of other favorite answer' do
      answer.favour
      new_answer.favour
      answer.reload
      expect(answer.user.awards.first).to be_nil
      expect(new_answer.user.awards.first.name).to eq "MyAward_#{new_answer.question.id}"
    end

    it 'favourite is first' do
      new_answer.favour
      expect(question.answers.first).to eq new_answer

      answer.favour
      expect(question.answers.first).to eq answer
    end
  end
end
