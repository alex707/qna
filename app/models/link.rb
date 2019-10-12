class Link < ApplicationRecord
  has_one :gist_content, dependent: :destroy

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates_format_of :url,
                      with: URI::DEFAULT_PARSER.make_regexp,
                      message: "'%{value}' is bad link."

  default_scope { includes(:gist_content) }

  def download!
    content = GistLoader.new(url).gist_content
    return unless content

    create_gist_content!(content: content)
  end
end
