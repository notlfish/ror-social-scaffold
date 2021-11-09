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
        respond_with User.find(params[:user_id]).posts.sort[params[:post_id].to_i - 1].comments.sort[params[:id].to_i - 1]
      end
    end
  end
end