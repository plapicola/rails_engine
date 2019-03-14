FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { 1234567891011120 }
    credit_card_expiration_date { 1 }
    result { 0 }
  end

  factory :failed_transaction, parent: :transaction do
    result { 1 }
  end
end
