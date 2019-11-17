class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[favour update destroy]

  after_action :publish_answer, only: %i[create]

  def favour
    if current_user.author?(@answer.question)
      @answer.favour
      @answers = @answer.question.answers
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
      @answer.links.each(&:download!)
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

  # rubocop:disable Style/SymbolArray
  def answer_params
    params.require(:answer).permit(
      :body, files: [], links_attributes: [:id, :name, :url, :_destroy]
    )
  end
  # rubocop:enable Style/SymbolArray

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def links_formatter
    @answer.links.map do |l|
      if l.gist_content&.content
        { gist_content: l.gist_content.content }
      else
        { name: l.name, url: l.url }
      end
    end
  end

  def files_attacher
    return [] unless @answer.files.attached?

    @answer.files.map do |file|
      {
        id: file.id,
        name: file.filename.to_s,
        url: url_for(file)
      }
    end
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@question.id}/answers",
      answer: @answer,
      links: links_formatter,
      files: files_attacher
    )
  end
end
