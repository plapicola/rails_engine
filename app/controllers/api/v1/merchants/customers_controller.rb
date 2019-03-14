class Api::V1::Merchants::CustomersController < ApplicationController
  def index
    render json: CustomerSerializer.new(Merchant.find(params[:merchant_id]).pending_customers)
  end
  def show
    render json: CustomerSerializer.new(Merchant.find(params[:merchant_id]).favorite_customer)
  end
end
