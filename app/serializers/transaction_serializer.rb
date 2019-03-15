class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :invoice_id, :result

  attribute :credit_card_number do |resource|
    resource.credit_card_number.to_s
  end
end
