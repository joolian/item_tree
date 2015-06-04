class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
		# Unique index on code that is case insensitive
    execute "CREATE UNIQUE INDEX index_items_lower_code ON items (lower(code))"
  end
end
