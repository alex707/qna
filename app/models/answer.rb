class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :favourite, -> { where(favourite: true) }
  scope :unfavourite, -> { where(favourite: false) }

  def favour
    ActiveRecord::Base.transaction do
      question.answers.favourite.update_all(favourite: false)
      update!(favourite: true)
    end
  end
end
