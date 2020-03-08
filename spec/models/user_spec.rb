require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'checking current user for author' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:question) { create(:question_with_answers, user: user) }
    let(:question2) { create(:question_with_own_answers, user: user) }

    it 'user is author of current question' do
      expect(user).to be_author(question)
    end

    it 'user is not author of current question' do
      expect(other_user).to_not be_author(question)
    end

    it 'user is author of current answer' do
      expect(user).to be_author(question2.answers.first)
    end

    it 'user is author of current answer' do
      expect(other_user).to_not be_author(question.answers.first)
    end
  end

  describe '#subscribed?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question) }
    let(:question2) { create(:question) }
    let!(:subscription) { create(:subscription, question: question, user: user) }
    let(:subscription2) { create(:subscription, question: question2, user: user2) }

    it 'user is subscribed on current question' do
      expect(user).to be_subscribed(question)
    end

    it 'user is not author of current question' do
      expect(user).to_not be_subscribed(question2)
    end
  end

  describe 'checking creating of authorization entity' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
    let(:auth2) { OmniAuth::AuthHash.new(provider: 'github', uid: '987654') }

    it 'creating authorization for user' do
      expect(user.authorizations).to be_empty
      expect {
        user.create_authorization!(auth)
      }.to change(Authorization, :count).by(1)

      expect(user.authorizations.first.provider).to eq auth.provider
      expect(user.authorizations.first.uid).to eq auth.uid
    end

    it 'creating more authorization for user' do
      user.create_authorization!(auth)
      expect(user.authorizations).not_to be_empty

      expect {
        user.create_authorization!(auth2)
      }.to change(Authorization, :count).by(1)

      expect(user.authorizations.last.provider).to eq auth2.provider
      expect(user.authorizations.last.uid).to eq auth2.uid
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
