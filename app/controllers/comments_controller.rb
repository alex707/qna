class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entity

  def create
    @comment = @commentable.comments.build(body: comment_params[:body])
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :id, :commentable)
  end

  def load_entity
    @commentable = comment_params[:commentable].classify.constantize.find(comment_params[:id])
  end
end
