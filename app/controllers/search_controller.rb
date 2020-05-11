class SearchController < ApplicationController
  def index
    return if search_params[:query].blank?

    @searched =
      if search_params[:type].nil?
        ThinkingSphinx.search ThinkingSphinx::Query.escape search_params[:query]
      elsif search_params[:type] == 'question'
        Question.search(ThinkingSphinx::Query.escape(search_params[:query]))
      elsif search_params[:type] == 'answer'
        Answer.search(ThinkingSphinx::Query.escape(search_params[:query]))
      elsif search_params[:type] == 'comment'
        Comment.search(ThinkingSphinx::Query.escape(search_params[:query]))
      elsif search_params[:type] == 'user'
        User.search(ThinkingSphinx::Query.escape(search_params[:query]))
      end
  end

  private

  def search_params
    params.permit(:query, :type)
  end
end
