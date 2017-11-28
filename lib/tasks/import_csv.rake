require 'csv'

task :import_customers, [:customers] => :environment do
  CSV.foreach('db/csv/customers.csv', :headers => true, header_converters: :symbol) do |row|
    Customer.create!(row.to_hash)
  end
end
