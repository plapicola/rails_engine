class Customer < ApplicationRecord
  has_many :invoices

  def transactions
    Transaction.unscoped
               .joins(:invoice)
               .where(invoices: {customer: self})
  end
end
