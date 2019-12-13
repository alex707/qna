class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entity

  after_action :publish_comment, only: %i[create]

  authorize_resource

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

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@comment.question.id}/created_comments",
      comment: @comment,
      commentable_id: @comment.commentable.id,
      commentable: @comment.commentable.class.to_s.downcase
    )
  end
end
