class CreatePlatters < ActiveRecord::Migration
  def change
    create_table :platters do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    add_index :platters, [:user_id, :created_at]
  end
end
