
desc "destroy and reload all seed data"
task :load_csv do
  Rake::Task["initialize"].invoke
  Rake::Task["load_customers"].invoke
  Rake::Task["load_invoices"].invoke
  Rake::Task["load_merchants"].invoke
  Rake::Task["load_items"].invoke
  Rake::Task["load_invoice_items"].invoke
  Rake::Task["load_transactions"].invoke
end

task initialize: :environment do
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["db:migrate"].invoke
  require './app/models/application_record.rb'
  require './app/models/customer.rb'
  require './app/models/invoice.rb'
  require './app/models/merchant.rb'
  require './app/models/item.rb'
  require './app/models/invoice_item.rb'
  require './app/models/transaction.rb'
end

desc "load customers"
task load_customers: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/customer.rb'
  CSV.foreach('./db/data/customers.csv', :headers => true,  header_converters: :symbol, :encoding => 'UTF-8') do |row|
    t = Customer.new
    t.first_name = row[:first_name]
    t.last_name = row[:last_name]
    t.save
    if t.save == false
      puts "Failed to add Customer ##{row[:id]} to database"
    end
  end
  puts "Customer CSV Database Upload Complete"
end

task load_invoice_items: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/invoice_item.rb'
  CSV.foreach('./db/data/invoice_items.csv', :headers => true,  header_converters: :symbol, converters: :all, :encoding => 'UTF-8') do |row|
    t = InvoiceItem.new
    t.quantity = row[:quantity].to_i
    t.unit_price = row[:unit_price].to_i
    t.status = row[:status]
    t.item_id = row[:item_id]
    t.invoice_id = row[:invoice_id]
    t.save
    if t.save == false
      puts "Failed to add InvoiceItem ##{row[:id]} to database"
    end
  end
  puts "InvoiceItem CSV Database Upload Complete"
end

task load_items: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/item.rb'
  CSV.foreach('./db/data/items.csv', :headers => true, header_converters: :symbol, :encoding => 'UTF-8') do |row|
    t = Item.new
    t.name = row[:name]
    t.description = row[:description]
    t.unit_price = row[:unit_price].to_i
    t.enabled = row[:enabled]
    t.merchant_id = row[:merchant_id]
    t.save
    if t.save == false
      puts "Failed to add Item ##{row[:id]} to database"
    end
  end
  puts "Item CSV Database Upload Complete"
end

task load_merchants: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/merchant.rb'
  CSV.foreach('./db/data/merchants.csv', :headers => true, header_converters: :symbol, :encoding => 'UTF-8') do |row|
    t = Merchant.new
    t.name = row[:name]
    t.save
    if t.save == false
      puts "Failed to add Merchant ##{row[:id]} to database"
    end
  end
  puts "Merchant CSV Database Upload Complete"
end

task load_transactions: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/transaction.rb'
  CSV.foreach('./db/data/transactions.csv', :headers => true, header_converters: :symbol, :encoding => 'UTF-8') do |row|
    t = Transaction.new
    t.invoice_id = row[:invoice_id]
    t.credit_card_number = row[:credit_card_number]
    t.credit_card_expiration_date = row[:credit_card_expiration_date]
    t.result = row[:result]
    t.save
    if t.save == false
      puts "Failed to add Transaction ##{row[:id]} to database"
    end
  end
  puts "Transaction CSV Database Upload Complete"
end

task load_invoices: :environment do
  require 'csv'
  require './app/models/application_record.rb'
  require './app/models/invoice.rb'
  CSV.foreach('./db/data/invoices.csv', :headers => true, header_converters: :symbol, :encoding => 'UTF-8') do |row|
    t = Invoice.new
    t.status = row[:status]
    t.customer_id = row[:customer_id]
    t.save
    if t.save == false
      puts "Failed to add Invoices ##{row[:id]} to database"
    end
  end
  puts "Invoice CSV Database Upload Complete"
end