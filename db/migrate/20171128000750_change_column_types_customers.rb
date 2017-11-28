class ChangeColumnTypesCustomers < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")
    
    change_table :customers do |t|
      t.change :first_name, :citext
      t.change :last_name,  :citext
    end
  end
end
