class Vote < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :voteable, polymorphic: true, required: true

  validates_inclusion_of :value, in: %w[like dislike], allow_nil: false
  validates :value, uniqueness: { scope: %i[user_id voteable_type voteable_id] }

  scope :likes, -> { where(value: 'like') }
  scope :dislikes, -> { where(value: 'dislike') }
end
