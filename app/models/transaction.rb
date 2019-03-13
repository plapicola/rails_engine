class Transaction < ApplicationRecord
  belongs_to :invoice
  scope :successful, -> { where(result: 0) }

  enum result: ['success', 'failed']
end
