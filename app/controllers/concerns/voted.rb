module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_voteable, only: [:vote]
  end

  def vote
    respond_to do |format|
      if @voteable.vote!(params[:value], current_user)
        format.json { render json: :ok, status: 200 }
      else
        format.json { render json: :error, status: :unprocessable_entity }
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:value, :id, :voteable)
  end

  def model_klass
    params[:voteable].classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end
end
