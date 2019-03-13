class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  def self.top_by_revenue(limit)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity / 100.0) as total_revenue')
    .where(transactions: {result: 0})
    .group(:id)
    .order('total_revenue desc')
    .limit(limit)
  end

  def self.top_by_items(limit)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.quantity) as total_quantity')
    .where(transactions: {result: 0})
    .group(:id)
    .order('total_quantity desc')
    .limit(limit)
  end

  def self.revenue_for_day(day)
    joins(invoices: [:invoice_items, :transactions])
    .select('SUM(invoice_items.unit_price * invoice_items.quantity / 100.0) as total_revenue')
    .where(transactions: {result: 0},
           invoices: {created_at: DateTime.parse(day + "UTC").all_day}
    )[0]
  end

  def revenue(date = nil)
    date_range = (date && DateTime.parse(date).all_day) || (Time.new(0)..Time.now)
    invoices.joins(:invoice_items, :transactions)
            .select('SUM(invoice_items.unit_price * invoice_items.quantity / 100.0) as total_revenue')
            .merge(Transaction.unscoped.successful)
            .where(created_at: date_range)[0]
  end
end
