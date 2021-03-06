class Question < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :award, dependent: :destroy

  has_many_attached :files

  belongs_to :user

  accepts_nested_attributes_for :award, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  def subscribe(user)
    subscriptions.create(user: user)
  end

  def unsubscribe(user)
    subscriptions.find_by(user: user)&.destroy
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
