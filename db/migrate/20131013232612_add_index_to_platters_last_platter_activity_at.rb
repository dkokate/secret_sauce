class AddIndexToPlattersLastPlatterActivityAt < ActiveRecord::Migration
  def change  
    add_index :platters, :last_platter_activity_at
  end
end
