class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]

  # rubocop:disable Naming/MemoizedInstanceVariableName
  def new
    @answer ||= @question.answers.new
  end
  # rubocop:enable Naming/MemoizedInstanceVariableName

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question

    if @answer.user == current_user
      @answer.destroy
      redirect_to question_path(@question), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path(@question), alert: 'Only owner can delete his answer.'
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
