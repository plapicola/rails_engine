FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { "" }
    credit_card_expiration_date { 1 }
    result { 1 }
  end
end
