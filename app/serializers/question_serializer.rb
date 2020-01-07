class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at, :short_title
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
