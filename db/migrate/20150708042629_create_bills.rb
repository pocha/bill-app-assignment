class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer :user_id 

      t.timestamps null: false
    end
  end
end
