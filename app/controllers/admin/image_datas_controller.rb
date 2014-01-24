class Admin::ImageDatasController < ApplicationController
  def index
  end

  def new
  end

  def create
    image_data = ImageData.new(:file => params[:file])
    image_data.origin_file_name = params[:file].original_filename
    image_data.save
    redirect_to "/image_datas/#{image_data.id}"
  end

  def show
    @image_data = ImageData.find(params[:id])
  end
end