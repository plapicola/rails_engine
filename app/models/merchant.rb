class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.top_by_revenue(limit)
    self.joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity / 100.0) as total_revenue')
    .where(transactions: {result: 0})
    .group(:id)
    .order('total_revenue desc')
    .limit(limit)
  end
end
