require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'checking current user for author' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question_with_answers, user: user) }

    it 'user is author of current question' do
      expect(user).to be_author(question)
    end

    it 'user is not author of current question' do
      expect(other_user).to_not be_author(question)
    end

    it 'user is author of current answer' do
      expect(user).to be_author(question.answers.first)
    end

    it 'user is author of current answer' do
      expect(other_user).to_not be_author(question.answers.first)
    end
  end
end
