class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question

  def create
    authorize! :create, Subscription

    @subscription = @question.subscribe!(current_user)
    if @subscription.errors.empty?
      flash.now[:notice] = 'You are subscribed for answer questions'
      render json: :ok, status: 200
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Subscription

    @subscription = @question.unsubscribe!(current_user)
    if @subscription.nil?
      flash.now[:notice] = "You are don't have any subscriptions on this question"
      render json: :ok, status: :not_modified
    elsif @subscription&.errors&.empty?
      flash.now[:notice] = 'You are unsubscribed for answer questions'
      render json: :ok, status: 200
    else
      render json: { errors: @subscription&.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params['question_id'])
  end
end
