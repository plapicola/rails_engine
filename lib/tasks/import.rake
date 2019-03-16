require 'csv'

desc "Import data from CSVs"
task import: :environment do
  CSV.foreach("./lib/data/customers.csv", headers: true) do |row|
    Customer.create(row.to_h)
  end
  puts "Imported customers."
  CSV.foreach("./lib/data/merchants.csv", headers: true) do |row|
    Merchant.create(row.to_h)
  end
  puts "Imported merchants."
  CSV.foreach("./lib/data/items.csv", headers: true) do |row|
    Item.create(row.to_h)
  end
  puts "Imported items."
  CSV.foreach("./lib/data/invoices.csv", headers: true) do |row|
    Invoice.create(row.to_h)
  end
  puts "Imported invoices."
  CSV.foreach("./lib/data/invoice_items.csv", headers: true) do |row|
    InvoiceItem.create(row.to_h)
  end
  puts "Imported invoice_items."
  CSV.foreach("./lib/data/transactions.csv", headers: true) do |row|
    Transaction.create(row.to_h)
  end
  puts "Imported transactions."
end
