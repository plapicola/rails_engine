class Api::V1::Merchants::CustomersController < ApplicationController
  def show
    render json: CustomerSerializer.new(Merchant.find(params[:merchant_id]).favorite_customer)
  end
end
