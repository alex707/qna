module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable
  end

  def vote!(value, voter)
    return if voter.nil? || voter.author?(self)
    return vote_off!(voter) if value.nil?

    transaction do
      vote = votes.find_or_initialize_by(user: voter)
      vote.update!(value: value)
    end
  end

  def likes
    votes.likes.count
  end

  def dislikes
    votes.dislikes.count
  end

  def voted?(user)
    Vote.exists?(user: user)
  end

  private

  def vote_off!(voter)
    vote = votes.find_by(user: voter)
    return true unless vote

    vote.destroy!
  end
end
