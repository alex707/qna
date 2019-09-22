class Answer < ApplicationRecord
  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :favourite, -> { where(favourite: true) }
  scope :unfavourite, -> { where(favourite: false) }
  default_scope { order(favourite: :desc) }

  def favour
    transaction do
      question.answers.favourite.update_all(favourite: false)
      update!(favourite: true)
    end
  end
end
