class ToysController < ApplicationController
  before_action :set_toy, only: [:show, :edit, :update, :destroy]

  def index
    @toys = Toy.all
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
        format.html { redirect_to @toy, notice: 'Toy was successfully created.' }
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
        format.html { redirect_to @toy, notice: 'Toy was successfully updated.' }
        format.json { render :show, status: :ok, location: @toy }
      else
        format.html { render :edit }
        format.json { render json: @toy.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @toy.destroy
    respond_to do |format|
      format.html { redirect_to toys_url, notice: 'Toy was successfully destroyed.' }
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
      params.require(:toy).permit(:name, :description, :url, :image_url, :text)
    end
end
