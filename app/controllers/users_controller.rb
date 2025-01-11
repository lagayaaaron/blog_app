class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @posts = @user.posts # Get the current user's posts
  end
end
