require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }
end
