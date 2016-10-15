class UserSessionsController < ApplicationController
  before_action :require_login, only: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:email], params[:password])
      redirect_back_or_to(root_url, notice: 'ログインしました')
    else
      flash.now[:alert] = 'ログインできませんでした'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_url, notice: 'ログアウトしました')
  end
end
