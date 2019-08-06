class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
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

  def remove_file
    @question = Question.find(params[:question_id])
    # @attached = ActiveStorage::Blob.find_signed(params[:signed_id])
    # @question = Question.joins(:files_blobs).where(
    #   active_storage_attachments: { blob_id: @attached.id }
    # )
    if current_user.author?(@question)
      @attached = @question.files.find(params[:file_id])
      @attached.purge
      flash.now[:notice] = 'Your files successfully removed.'
    else
      flash.now[:alert] = 'Only owner can remove files of his question.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end
end
