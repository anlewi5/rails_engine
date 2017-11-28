class ChangeCardNumberTransactions < ActiveRecord::Migration[5.1]
  def change
    change_table :transactions do |t|
      t.change :credit_card_number, :bigint
    end
  end
end
