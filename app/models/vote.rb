class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates_inclusion_of :value, in: %w[like dislike none], allow_nil: false

  scope :likes, -> { where(value: 'like') }
  scope :dislikes, -> { where(value: 'dislike') }
end
