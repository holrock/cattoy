class CatsController < ApplicationController
  before_action :require_login, except: :show

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new(user: current_user)
  end

  def create
    @cat = current_user.cats.new(cat_params)
    if @cat.save
      redirect_to user_path(current_user), notice: '猫を登録しました'
    else
      render :new
    end
  end

  def edit
    @cat = current_user.cats.find(params[:id])
  end

  def update
  end

  def destroy
    @cat = current_user.cats.find(params[:id])
    @cat.destroy
    redirect_to user_path(current_user), notice: '登録解除しました'
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :image_url)
  end
end
