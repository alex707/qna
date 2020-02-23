require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  describe 'subscription uniqueness' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    subject { Subscription.new(user: user, question: question) }

    it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  end
end
