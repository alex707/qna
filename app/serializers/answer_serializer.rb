class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :updated_at, :created_at, :files

  has_many :comments
  has_many :links

  belongs_to :user

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
