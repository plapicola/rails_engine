class Customer < ApplicationRecord
  has_many :invoices

  def transactions
    Transaction.unscoped
               .joins(:invoice)
               .where(invoices: {customer: self})
  end

  def favorite_merchant
    Merchant.select("merchants.*, count(transactions.id) AS transaction_count")
            .joins(invoices: :transactions)
            .merge(Transaction.unscoped.successful)
            .where(invoices: {customer_id: self.id})
            .group(:id)
            .order("transaction_count DESC")
            .first
  end
end
