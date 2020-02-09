module Api
  module V1
    class ProfilesController < BaseController
      def index
        @users = User.where.not(id: current_resource_owner)
        render json: @users
      end

      def me
        render json: current_resource_owner
      end
    end
  end
end
