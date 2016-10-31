class ToysController < ApplicationController
  before_action :set_toy, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:index, :show]

  def index
    tag_id = params[:tag].to_i
    if tag_id.nonzero?
      @tag = ActsAsTaggableOn::Tag.find(tag_id)
      @toys = Toy.joins(:taggings).
        where('taggings.tag_id = ?', tag_id).
        order(updated_at: :desc)
    else
      @toys = Toy.all.order(updated_at: :desc)
    end
    @votes = History.votes
    @most_used_tags = ActsAsTaggableOn::Tag.most_used(10)
  end

  def show
  end

  def new
    @toy = Toy.new
  end

  def edit
  end

  def create
    @toy = Toy.new(toy_params)

    respond_to do |format|
      if @toy.save
        format.html { redirect_to @toy, notice: '登録しました' }
        format.json { render :show, status: :created, location: @toy }
      else
        format.html { render :new }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @toy.update(toy_params)
        format.html { redirect_to @toy, notice: '更新しました' }
        format.json { render :show, status: :ok, location: @toy }
      else
        format.html { render :edit }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # 未実装
    #@toy.destroy
    respond_to do |format|
      format.html { redirect_to toys_url, notice: '削除しましてません' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_toy
      @toy = Toy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def toy_params
      params.require(:toy).permit(:name, :description, :url, :image_url, :tag_list)
    end
end
