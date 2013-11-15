class AddLastPlatterActivityAtToPlatters < ActiveRecord::Migration
  def change
    add_column :platters, :last_platter_activity_at, :timestamp
  end
end
