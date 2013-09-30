class AddIndexToRelationships < ActiveRecord::Migration
  def change
  remove_index :relationships, :column => [:follower_id, :follower_id]  
  add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
