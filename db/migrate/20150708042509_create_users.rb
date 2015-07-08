class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.boolean :is_employee
      t.boolean :is_affiliate
      t.date :registered_on
      t.string :name

      t.timestamps null: false
    end
  end
end
