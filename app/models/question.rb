class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  has_one_attached :file

  belongs_to :user

  validates :title, :body, presence: true
end
