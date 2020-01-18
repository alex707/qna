module Api
  module V1
    class AnswersController < BaseController
      before_action :load_question, only: %i[create]
      before_action :load_answer, only: %i[show update destroy]

      authorize_resource

      def show
        render json: @answer
      end

      def create
        @answer = @question.answers.build(answer_params)
        @answer.user = current_user

        if @answer.save
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer
        else
          render json: @answer.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy
        render json: @answer
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
    end
  end
end
