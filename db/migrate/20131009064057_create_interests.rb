class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
      t.integer :user_id
      t.integer :platter_id

      t.timestamps
    end
    add_index :interests, :user_id
    add_index :interests, :platter_id
    add_index :interests, [:user_id, :platter_id], unique: true
  end
end
