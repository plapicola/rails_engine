class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :item_id, :invoice_id, :quantity

  attribute :unit_price do |resource|
    (resource.unit_price / 100.0).to_s
  end
end
