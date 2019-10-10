class Link < ApplicationRecord
  has_one :gist_content, dependent: :destroy

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates_format_of :url,
                      with: URI::DEFAULT_PARSER.make_regexp,
                      message: "'%{value}' is bad link."

  def download
    content = GistLoader.new(url).gist_content
    return unless content

    gist_content&.destroy
    build_gist_content(content: content)
  end
end
