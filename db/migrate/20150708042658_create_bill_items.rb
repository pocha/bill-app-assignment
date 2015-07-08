class CreateBillItems < ActiveRecord::Migration
  def change
    create_table :bill_items do |t|
      t.integer :bill_id
      t.integer :item_id
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
