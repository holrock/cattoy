class HistoriesController < ApplicationController
  before_action :require_login, except: %i(index show)

  def index
    @histories = History.all
  end

  def show
    @history = History.find(params[:id])
  end

  def new
    @toy = Toy.find(params[:toy])
    rate = params[:rate].to_i
    @histories = current_user.cats.includes(:histories).map do |cat|
      hist = cat.histories.to_a.find { |i| i.toy_id == @toy.id }
      if hist
        hist
      else
        History.new(toy: @toy, cat: cat, rate: rate)
      end
    end
  end

  def create
    @history = History.new(history_params)
    unless current_user.cats.exists?(id: @history.cat.id)
      @history.errors.add('mismatch cat and user')
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @histories.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @history.save
        format.html { redirect_to @toy, notice: '更新しました' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @histories.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @history = History.find(params[:id])
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: '更新しました' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

  def history_params
    params.require(:history).permit(:toy_id, :cat_id, :rate, :comment)
  end
end
