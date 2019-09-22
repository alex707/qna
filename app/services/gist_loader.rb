require 'net/https'

# need for load gist by url
class GistLoader
  URL_PATTERN = %r{^https:\/\/gist.github.com}.freeze

  def initialize(link)
    @link = link
  end

  def gist_content
    return unless @link =~ URL_PATTERN

    load_data
  end

  private

  def gist_link
    m = @link.match(/[a-zA-Z0-9]{32}$/)
    "https://api.github.com/gists/#{m[0]}" if m
  end

  def load_data
    return unless gist_link

    response = Net::HTTP.get_response(URI(gist_link))
    return unless response.is_a?(Net::HTTPSuccess)

    e = JSON.parse(response.body)
    e['files'].values.first['content']
  end
end
