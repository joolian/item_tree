class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :description
      t.boolean :done
      t.integer :item_id

      t.timestamps null: false
    end
  end
end
