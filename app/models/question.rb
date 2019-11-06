class Question < ApplicationRecord
  include Linkable
  include Voteable

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached :files

  belongs_to :user

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true
end
