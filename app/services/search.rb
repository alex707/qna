module Services
  # for searching by  resources
  class Search
    attr_reader :query, :type

    RESOURCES = %w[question answer comment user].freeze

    def initialize(params = {})
      @query = ThinkingSphinx::Query.escape(params[:query]) if params.fetch(:query, nil)
      @type = params.fetch(:type, nil)
    end

    def call
      return if query.nil?

      if type.nil?
        ThinkingSphinx.search(query)
      elsif RESOURCES.include?(type.downcase)
        type.capitalize.constantize.search(query)
      else
        raise 'Wrong type of resource'
      end
    end
  end
end
