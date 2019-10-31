require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :voteable }

  it { should validate_inclusion_of(:value).in_array(%w[like dislike]) }
  it { should_not allow_value(nil).for(:value) }

  describe 'uniqueness test' do
    subject { create(:vote) }
    it do
      should validate_uniqueness_of(:value)
        .scoped_to(%i[user_id voteable_type voteable_id])
    end
  end
end
