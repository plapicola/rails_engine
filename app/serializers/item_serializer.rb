class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |resource|
    (resource.unit_price / 100.0).to_s
  end
end
