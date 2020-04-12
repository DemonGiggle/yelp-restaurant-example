class RestaurantsController < ApplicationController
  def index
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.includes(:periods).order(id: :desc).page(params[:page]).per(3)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end
end
