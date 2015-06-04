class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :ancestry
      t.boolean :is_location, default: false
      t.string :ancestry
      t.integer :item_id

      t.timestamps null: false
    end
    add_index :locations, :ancestry
  end
end
