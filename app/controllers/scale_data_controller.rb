class ScaleDataController < ApplicationController
  before_action :set_scale_datum, only: [:show, :update, :destroy]

  # GET /scale_data
  def index
    @scale_data = ScaleDatum.all

    render json: @scale_data
  end

  # GET /scale_data/1
  def show
    render json: @scale_datum
  end

  # POST /scale_data
  def create
    @scale_datum = ScaleDatum.new(scale_datum_params)

    if @scale_datum.save
      render json: @scale_datum, status: :created, location: @scale_datum
    else
      render json: @scale_datum.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scale_data/1
  def update
    if @scale_datum.update(scale_datum_params)
      render json: @scale_datum
    else
      render json: @scale_datum.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scale_data/1
  def destroy
    @scale_datum.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scale_datum
      @scale_datum = ScaleDatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def scale_datum_params
      params.require(:scale_datum).permit(:date, :keydata, :model, :tag)
    end
end
