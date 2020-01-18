module Api
  module V1
    class QuestionsController < BaseController
      before_action :load_question, only: %i[show update destroy]
      # after_action :publish_question, only: :create

      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question
      end

      def create
        @question = Question.new(question_params)
        @question.user = current_resource_owner

        if @question.save
          render json: @question
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question
        else
          render json: @question.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
        render json: @question
      end

      private

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

      def load_question
        @question = Question.with_attached_files.find(params[:id])
        gon.question_id = @question.id
      end

      def publish_question
        return if @question.errors.any?

        ActionCable.server.broadcast(
          'questions',
          ApplicationController.render(
            partial: 'questions/question_preview',
            locals: { question: @question }
          )
        )
      end
    end
  end
end
