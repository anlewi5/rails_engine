class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")

    create_table :transactions do |t|
      t.citext     :result
      t.references :invoice
      t.integer    :credit_card_number
      t.integer    :credit_card_expiration_date
      
      t.timestamps
    end
  end
end
