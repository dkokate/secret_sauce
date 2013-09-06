class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :instructions
      t.integer :user_id
      t.integer :total_calories

      t.timestamps
    end
    add_index :recipes, [:user_id, :created_at]
  end
end
