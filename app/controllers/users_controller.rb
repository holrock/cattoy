class UsersController < ApplicationController
  before_action :require_login, except: %i(show new create edit update)

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_url, notice: 'ユーザーが作成されました'
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    raise 'user mismatched' unless @user == current_user
    if @user.update(user_params)
      redirect_to root_url, notice: '更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
