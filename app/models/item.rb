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

  def best_day
    # Invoice.select("invoices.created_at AS best_day, SUM(invoice_items.quantity) as volume")
    #        .joins(:items, :transactions)
    #        .merge(Transaction.unscoped.successful)
    #        .where(invoice_items: {item_id: self.id})
    #        .group(:created_at)
    #        .order('volume desc, invoices.created_at desc').first

    Invoice.select("invoices.created_at AS best_day, SUM(invoice_items.quantity) as total_quantity")
           .joins(:transactions)
           .joins("INNER JOIN invoices b ON invoices.created_at <= b.created_at AND invoices.created_at >= b.created_at - '1 day'::INTERVAL")
           .joins("INNER JOIN invoice_items ON invoice_items.invoice_id = b.id")
           .merge(Transaction.unscoped.successful)
           .where(invoice_items: {item_id: self.id})
           .where(merchant_id: self.merchant_id, id: InvoiceItem.where(item_id: self.id).pluck(:invoice_id))
           .group(:id)
           .order('total_quantity DESC, invoices.created_at DESC').first
  end
end
