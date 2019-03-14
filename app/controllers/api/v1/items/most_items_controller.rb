class Api::V1::Items::MostItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.top_by_items(params[:quantity]))
  end
end
