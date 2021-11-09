module Api
  module V1
    class CommentsController < ApplicationController
      respond_to :json
      before_action :authenticate_user!
      class Comment < ::Comment
      end

      def index
        respond_with User.find(params[:user_id]).posts.sort[params[:post_id].to_i - 1].comments.sort
      end

      def show
        respond_with Comment.where(params[:user_id, :post_id])
      end

      def create
        @comment = Comment.new(comment_params)
        @comment.post_id = params[:post_id]
        @comment.user = current_user

        if @comment.save
          render json: @comment
        else
          render error: { error: 'unable to create comment.' }, status: 400
        end
      end

      private

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
