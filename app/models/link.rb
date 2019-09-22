class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validates_format_of :url,
                      with: URI::DEFAULT_PARSER.make_regexp,
                      message: "'%{value}' is bad link."

  def gist_content
    GistLoader.new(url).gist_content
  end
end
