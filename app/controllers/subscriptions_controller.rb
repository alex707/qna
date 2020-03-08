class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_subscription, only: :destroy

  def create
    authorize! :create, Subscription

    @subscription = @question.subscribe(current_user)
    if @subscription.errors.empty?
      flash.now[:notice] = 'You are subscribed for answer questions'
      render json: { id: @subscription.id, result: 'subscribe' }, status: :ok
    else
      render json: { errors: @subscription.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, Subscription

    @subscription.question.unsubscribe(current_user)
    if @subscription&.errors&.empty?
      flash.now[:notice] = 'You are unsubscribed for answer questions'
      render json: { id: @subscription.id, result: 'unsubscribe' },status: :ok
    else
      render json: { errors: @subscription&.errors }, status: :unprocessable_entity
    end
  end

  private

  def load_question
    @question = Question.find(params['question_id'])
  end

  def load_subscription
    @subscription = current_user.subscriptions.find(params['id'])
  end
end
