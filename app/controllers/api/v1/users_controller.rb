module Api
  module V1
    class UsersController < ApplicationController
      respond_to :json
      before_action :authenticate_user!
      class User < ::User
      end

      def index
        @users = User.all
        respond_with @users
      end

      def show
        @user = User.find(params[:id])
        respond_with @user
      end
    end
  end
end
