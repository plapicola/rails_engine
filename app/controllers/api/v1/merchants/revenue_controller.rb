class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: RevenueSerializer.new(Merchant.revenue_for_day(params[:date]))
  end

  def show
    render json: RevenueSerializer.new(Merchant.find(params[:merchant_id]).revenue(params[:date]))
  end
end
