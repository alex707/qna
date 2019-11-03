class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_entity

  def vote
    respond_to do |format|
      if @voteable.vote!(params[:value], current_user)
        format.json { render json: :ok, status: 200 }
      else
        format.json { render json: { error: 'Only not owner can vote.' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:value, :id, :voteable)
  end

  def load_entity
    model_klass = params[:voteable].classify.constantize
    @voteable = model_klass.find(params[:id])
  end
end
