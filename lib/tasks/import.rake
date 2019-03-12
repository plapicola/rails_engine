require 'csv'

namespace :import do
  desc "Import customers from CSV"
  task customers: :environment do
    CSV.foreach("./lib/data/customers.csv", headers: true) do |row|
      Customer.create(row.to_h)
    end
    puts "Imported customers."
  end

  desc "Import merchants from CSV"
  task merchants: :environment do
    CSV.foreach("./lib/data/merchants.csv", headers: true) do |row|
      Merchant.create(row.to_h)
    end
    puts "Imported merchants."
  end

  desc "Import items from CSV"
  task items: :environment do
    CSV.foreach("./lib/data/items.csv", headers: true) do |row|
      Item.create(row.to_h)
    end
    puts "Imported items."
  end

  desc "Import invoices from CSV"
  task invoices: :environment do
    CSV.foreach("./lib/data/invoices.csv", headers: true) do |row|
      Invoice.create(row.to_h)
    end
    puts "Imported invoices."
  end

  desc "Import invoice_items from CSV"
  task invoice_items: :environment do
    CSV.foreach("./lib/data/invoice_items.csv", headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
    puts "Imported invoice_items."
  end

  desc "Import transactions from CSV"
  task transactions: :environment do
    CSV.foreach("./lib/data/transactions.csv", headers: true) do |row|
      Transaction.create(row.to_h)
    end
    puts "Imported transactions."
  end

end
