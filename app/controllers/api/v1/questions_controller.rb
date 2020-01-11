module Api
  module V1
    class QuestionsController < BaseController
      before_action :load_question, only: %i[show]

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        render json: @question
      end

      private

      def load_question
        @question = Question.with_attached_files.find(params[:id])
      end
    end
  end
end
