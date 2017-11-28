class CreateItems < ActiveRecord::Migration[5.1]
  def change
    enable_extension("citext")

    create_table :items do |t|
      t.citext      :name
      t.citext      :description
      t.integer     :unit_price
      t.references  :merchant
      
      t.timestamps
    end
  end
end
