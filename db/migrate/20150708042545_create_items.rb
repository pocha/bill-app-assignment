class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.integer :cost
      t.boolean :is_grocery, default: false
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
