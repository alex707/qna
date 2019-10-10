class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.build
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_award
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      @question.links.each(&:download!)
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if current_user.author?(@question)
      @question.update(question_params)
      flash.now[:notice] = 'Your question successfully updated.'
    else
      flash.now[:alert] = 'Only owner can update his question.'
    end
  end

  def destroy
    unless current_user&.author? @question
      redirect_to question_path(@question), alert: 'Only owner can delete his question.'
      return
    end

    @question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted.'
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  # rubocop:disable Style/SymbolArray
  def question_params
    params.require(:question).permit(
      :title,
      :body,
      files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:name, :image]
    )
  end
  # rubocop:enable Style/SymbolArray
end
