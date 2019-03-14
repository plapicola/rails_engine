class Api::V1::Items::BestDayController < ApplicationController
  def show
    render json: BestDaySerializer.new(Item.find(params[:item_id]).best_day)
  end
end
