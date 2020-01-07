module Api
  module V1
    class ProfilesController < BaseController
      def me
        render json: current_resource_owner
      end
    end
  end
end
