module Api
  module V1
    class PostsController < ApplicationController
      respond_to :json
      before_action :authenticate_user!
      class Post < ::Post
      end

      def index
        respond_with Post.where(user_id: params[:user_id]).sort
      end

      def show
        respond_with Post.where(user_id: params[:user_id]).sort[params[:id].to_i - 1]
      end
    end
  end
end