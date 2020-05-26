class SearchController < ApplicationController
  def index
    @searched = Services::Search.new(search_params).call
  end

  private

  def search_params
    params.permit(:query, :type)
  end
end
