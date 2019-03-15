FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { 1 }
  end

  factory :unshipped_invoice, parent: :invoice do
    status { 0 }
  end
end
