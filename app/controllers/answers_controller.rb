class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[favour update destroy]

  def favour
    if current_user.author?(@answer.question)
      @answer.favour
      flash.now[:notice] = 'Answer marked as favourite.'
    else
      flash.now[:alert] = 'Only question owner can make favourite the answer.'
    end
  end

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
    @question = @answer.question

    if current_user.author?(@answer)
      @answer.update(answer_params)
      flash.now[:notice] = 'Your answer successfully updated.'
    else
      flash.now[:alert] = 'Only owner can update his answer.'
    end
  end

  def destroy
    @question = @answer.question

    if current_user&.author?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Answer successfully deleted.'
    else
      flash.now[:alert] = 'Only owner can delete his answer.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
