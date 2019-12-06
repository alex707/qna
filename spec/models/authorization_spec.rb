require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }

  it { validate_presence_of(:provider) }
  it { validate_presence_of(:uid) }
end
