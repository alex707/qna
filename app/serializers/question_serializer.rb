class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :updated_at, :created_at, :short_title, :files

  has_many :answers
  has_many :comments
  has_many :links

  belongs_to :user

  def short_title
    object.title.truncate(7)
  end

  def files
    return [] unless object.files.attached?

    object.files.map do |file|
      {
        id: file.id,
        filename: file.filename.to_s,
        url: url_for(file),
        created_at: file.created_at
      }
    end
  end
end
