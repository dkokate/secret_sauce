class Recipe < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :instructions, presence: true
  
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                          WHERE follower_id = :user_id"
    user.followed_user_ids
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",  user_id: user)
  end
end
