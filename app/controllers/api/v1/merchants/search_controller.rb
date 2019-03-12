class Api::V1::Merchants::SearchController < ApplicationController
  def show
    render json: Merchant.find_by(merchant_params)
  end

  private

  def merchant_params
    params.permit(:id, :name, :updated_at, :created_at)
  end
end
