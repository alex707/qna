class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true

  default_scope { order(created_at: :asc) }

  def question
    commentable.is_a?(Question) ? commentable : commentable.question
  end
end
