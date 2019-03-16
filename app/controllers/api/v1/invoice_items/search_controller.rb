class Api::V1::InvoiceItems::SearchController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.where(invoice_item_params))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(invoice_item_params))
  end

  private

  def invoice_item_params
    params[:unit_price] = (params[:unit_price].to_f * 100).round(0) if params[:unit_price]
    params.permit(:id, :invoice_id, :item_id, :quantity, :unit_price, :created_at, :updated_at)
  end
end
