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
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      flash.now[:alert] = 'An error(s) occurred while saving answer'
      render 'questions/show'
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
