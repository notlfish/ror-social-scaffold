class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.xml { render :xml => @users }
      format.json { render :json => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
end
