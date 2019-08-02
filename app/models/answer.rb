class Answer < ApplicationRecord
  has_one :question, foreign_key: :accepted_id

  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def accept
    question.accepted_id = id
    question.save
  end

  def accepted?
    id == question.accepted_id
  end
end
