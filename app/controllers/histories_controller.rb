class HistoriesController < ApplicationController
  before_action :require_login, except: %i(index show)

  def index
    @histories = History.all
  end

  def show
    @history = History.find(params[:id])
  end

  def new
    toy = Toy.find(params[:toy])
    @history = History.new(toy_id: toy.id, rate: params[:rate].to_i)
  end

  def create
    @history = History.new(history_params)
    unless current_user.cats.exists?(id: @history.cat.id)
      @history.errors.add('mismatch cat and user')
      render :new
      return
    end

    if @history.save
      redirect_to toy_path(@history.toy), notice: '登録しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy

  end

  private

  def history_params
    params.require(:history).permit(:toy_id, :cat_id, :rate, :comment)
  end
end
