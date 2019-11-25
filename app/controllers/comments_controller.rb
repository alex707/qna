class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entity

  def comment
    @commentable.comments.new(body: params[:body], user: current_user)
    @commentable.save
    respond_to do |format|
      if @commentable.errors.any?
        format.json { render json: { error: @commentable.errors },
          status: :unprocessable_entity }
      else
        format.json { render json: :ok, status: 200 }
      end
    end
  end

  private

  def vote_params
    params.require(:comment).permit(:body, :id, :commentable)
  end

  def load_entity
    @commentable = params[:commentable].classify.constantize.find(params[:id])
  end
end
