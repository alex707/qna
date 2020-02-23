class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def subscribe
    authorize! :subscribe!, @question

    @subscription = @question.subscribe!(current_user)
    if @subscription.errors.empty?
      flash.now[:notice] = 'You are subscribed for answer questions'
      render json: :ok, status: 200
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end

  def unsubscribe
    authorize! :unsubscribe!, @question

    @subscription = @question.unsubscribe!(current_user)
    if @subscription
      flash.now[:notice] = 'You are unsubscribed for answer questions'
      render json: :ok, status: 200
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params['question_id'])
  end
end
