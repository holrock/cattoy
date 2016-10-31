class UsersController < ApplicationController
  before_action :require_login, except: %i(show new create)

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_url, notice: 'ユーザーが作成されました。ログイン後、猫を登録してください。'
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_url(current_user)
      return
    end
    if @user.update(user_params)
      redirect_to user_url(@user), notice: '更新しました'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
