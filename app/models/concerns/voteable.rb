module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote(value, voter)
    return if voter.id == user.id

    vote = votes.find_or_create_by(user: voter)
    vote.update!(value: value)
  end

  def likes
    votes.likes
  end

  def dislikes
    votes.dislikes
  end
end
