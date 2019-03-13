class Api::V1::Merchants::RevenueController < ApplicationController
  def index
    render json: RevenueSerializer.new(Merchant.revenue_for_day(params[:date]))
  end
end
