module Api
  module V1
    class AnswersController < BaseController
      before_action :load_answer, only: %i[show]

      def show
        render json: @answer
      end

      private

      def load_answer
        @answer = Answer.with_attached_files.find(params[:id])
      end
    end
  end
end
