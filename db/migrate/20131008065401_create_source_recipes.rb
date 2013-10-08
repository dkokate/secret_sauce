class CreateSourceRecipes < ActiveRecord::Migration
  def change
    create_table :source_recipes do |t|
      t.string :source
      t.string :recipe_ref
      t.string :name
      t.text :ingredients
      t.integer :total_time_in_seconds
      t.string :small_image_url
      t.string :source_display_name

      t.timestamps
    end
  end
end
