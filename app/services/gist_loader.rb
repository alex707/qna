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

  def gist_path
    m = @link.match(/[a-zA-Z0-9]{32}$/)
    "gists/#{m[0]}" if m
  end

  def load_data
    return unless gist_path

    response = Faraday.new('https://api.github.com/').get(gist_path)
    return if response&.body&.empty?

    e = JSON.parse(response.body)
    e['files']&.values&.first&.try(:[], 'content')
  rescue Faraday::ConnectionFailed => e
    Rails.logger.info "Connection failed: #{e}"
    nil
  end
end
