class CreateSelections < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.integer :platter_id
      t.integer :source_recipe_id

      t.timestamps
    end
    add_index :selections, :platter_id
    add_index :selections, :source_recipe_id
    add_index :selections, [:platter_id, :source_recipe_id], unique: true
  end
end
