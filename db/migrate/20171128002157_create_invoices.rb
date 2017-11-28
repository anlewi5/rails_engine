class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")
    
    create_table :invoices do |t|
      t.references  :customer
      t.references  :merchant
      t.citext      :status

      t.timestamps
    end
  end
end
