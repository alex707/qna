require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Link }
    it { should be_able_to :read, Award }
    it { should be_able_to :read, Vote }

    it { should be_able_to :search, Question }
    it { should be_able_to :search, Answer }
    it { should be_able_to :search, Comment }
    it { should be_able_to :search, User }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:answer) do
      q = build(:question, user: user)
      build(:answer, user: other, question: q)
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Award }
    it { should be_able_to :create, Vote }
    it { should be_able_to :create, Subscription }
    it { should be_able_to :create, build(:question, user: user).links.build }
    it { should_not be_able_to :create, build(:link) }

    it { should be_able_to :update, build(:question, user: user) }
    it { should_not be_able_to :update, build(:question, user: other) }
    it { should be_able_to :update, build(:answer, user: user) }
    it { should_not be_able_to :update, build(:answer, user: other) }
    it { should be_able_to :update, build(:vote, user: user) }
    it { should_not be_able_to :update, build(:vote, user: other) }

    it { should be_able_to :destroy, build(:question, user: user) }
    it { should_not be_able_to :destroy, build(:question, user: other) }
    it { should be_able_to :destroy, build(:answer, user: user) }
    it { should_not be_able_to :destroy, build(:answer, user: other) }
    it { should be_able_to :destroy, build(:question, user: user).links.build }
    it { should_not be_able_to :destroy, build(:link) }
    it { should be_able_to :destroy, build(:vote, user: user) }
    it { should_not be_able_to :destroy, build(:vote, user: other) }

    it { should_not be_able_to :vote!, build(:question, user: user) }
    it { should be_able_to :vote!, build(:question, user: other) }
    it { should_not be_able_to :vote!, build(:answer, user: user) }
    it { should be_able_to :vote!, build(:answer, user: other) }

    it { should_not be_able_to :favour, create(:answer, user: other) }
    it { should be_able_to :favour, answer }

    it { should be_able_to :destroy, build(:subscription, user: user) }
    it { should_not be_able_to :destroy, build(:subscription, user: other) }
  end
end
