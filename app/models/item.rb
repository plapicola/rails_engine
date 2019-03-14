class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  default_scope { order(:id) }

  def self.top_by_items(limit)
    unscoped.select("items.*, SUM(invoice_items.quantity) AS total_quantity")
    .joins(invoices: :transactions)
    .merge(Transaction.unscoped.successful)
    .group(:id)
    .order('total_quantity DESC')
    .limit(limit)
  end

  def self.top_by_revenue(limit)
    unscoped.select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue")
    .joins(invoices: :transactions)
    .merge(Transaction.unscoped.successful)
    .group(:id)
    .order('total_revenue DESC')
    .limit(limit)
  end
end
