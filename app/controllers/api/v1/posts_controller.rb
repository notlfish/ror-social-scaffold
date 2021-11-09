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

      def create
        @post = current_user.posts.new(post_params)

        if @post.save
          render json: @post
        else
          render error: { error: 'unable to create post.' }, status: 400
        end
      end

      private

      def post_params
        params.require(:post).permit(:content)
      end
    end
  end
end
