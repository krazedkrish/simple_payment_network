class UsersController < ApplicationController
  def index
    @users = User.includes(:wallet).all.page params[:page]
  end

  def show
    @user = User.includes(:wallet).find(params[:id])
  end
end
