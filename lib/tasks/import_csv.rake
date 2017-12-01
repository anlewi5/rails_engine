require 'csv'

task :import_customers, [:customers] => :environment do
  CSV.foreach('db/csv/customers.csv', :headers => true, header_converters: :symbol) do |row|
    Customer.create!(row.to_hash)
  end
end

task :import_invoice_items, [:invoice_items] => :environment do
  CSV.foreach('db/csv/invoice_items.csv', :headers => true, header_converters: :symbol) do |row|
    InvoiceItem.create!(row.to_hash)
  end
end

task :import_invoices, [:invoices] => :environment do
  CSV.foreach('db/csv/invoices.csv', :headers => true, header_converters: :symbol) do |row|
    Invoice.create!(row.to_hash)
  end
end

task :import_items, [:items] => :environment do
  CSV.foreach('db/csv/items.csv', :headers => true, header_converters: :symbol) do |row|
    Item.create!(row.to_hash)
  end
end

task :import_merchants, [:merchants] => :environment do
  CSV.foreach('db/csv/merchants.csv', :headers => true, header_converters: :symbol) do |row|
    Merchant.create!(row.to_hash)
  end
end

task :import_transactions, [:transactions] => :environment do
  CSV.foreach('db/csv/transactions.csv', :headers => true, header_converters: :symbol) do |row|
    Transaction.create!(row.to_hash)
  end
end

task :import_all do
  Rake::Task["import_merchants"].invoke
  Rake::Task["import_items"].invoke
  Rake::Task["import_customers"].invoke
  Rake::Task["import_invoices"].invoke
  Rake::Task["import_invoice_items"].invoke
  Rake::Task["import_transactions"].invoke
end
