class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash.now[:notice] = 'Your answer successfully created.'
    else
      flash.now[:alert] = 'An error(s) occurred while saving answer'
    end
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if current_user.author?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Your answer successfully updated.'
    else
      flash.now[:alert] = 'Only owner can update his answer.'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user&.author? @answer
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path(@answer.question), alert: 'Only owner can delete his answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
