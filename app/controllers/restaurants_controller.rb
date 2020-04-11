class RestaurantsController < ApplicationController
  def index
    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.order(id: :desc).page(params[:page])
  end

  def show
  end
end
