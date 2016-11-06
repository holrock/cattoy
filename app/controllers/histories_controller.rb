class HistoriesController < ApplicationController
  before_action :require_login, except: %i(index show)

  def index
    @histories = History.order(updated_at: :desc).limit(50).includes(:toy, cat: [:user])
  end

  def show
    @history = History.find(params[:id])
  end

  def new
    @toy = Toy.find(params[:toy])
    set_user_histories(@toy)
  end

  def create
    @history = History.new(history_params)
    @toy = @history.toy
    unless current_user.cats.exists?(id: @history.cat.id)
      set_user_histories(@toy)
      @history.errors[:base] << 'mismatch cat and user'
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @histories.errors, status: :unprocessable_entity }
      end
      return
    end

    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: '更新しました' }
        format.json { render :show, status: :created, location: @history }
      else
        set_user_histories(@toy)
        format.html { render :new }
        format.json { render json: @histories.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @history = History.find(params[:id])
    raise 'user mismatched' unless @history.cat.user == current_user
  end

  def update
    @history = History.find(params[:id])
    @toy = @history.toy
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: '更新しました' }
        format.json { render :show, status: :ok, location: @history }
      else
        set_user_histories(@toy)
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  #def destroy
  #end

  private

  def history_params
    params.require(:history).permit(:toy_id, :cat_id, :rate, :comment)
  end

  def set_user_histories(toy)
    rate = params[:rate].to_i
    @histories = current_user.cats.includes(:histories).map do |cat|
      hist = cat.histories.to_a.find { |i| i.toy_id == toy.id }
      if hist
        hist
      else
        History.new(toy: toy, cat: cat, rate: rate)
      end
    end
  end
end
