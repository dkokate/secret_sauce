class Platter < ActiveRecord::Base
  belongs_to :user
  has_many :selections, dependent: :destroy
  has_many :interests, dependent: :destroy
  # default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  # validates :last_platter_activity_at, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  before_save { self.last_platter_activity_at = DateTime.now.utc }
  
  def self.from_platters_followed_by(user)
    # All platters of interest of a user..this includes platters owned and platters followed
    followed_platter_ids = "SELECT platter_id FROM interests
                          WHERE user_id = :user_id"
    where("id IN (#{followed_platter_ids}) OR user_id = :user_id",  user_id: user).order('last_platter_activity_at DESC')
  end
  
  def self.platters_followed_by(user)
      followed_platter_ids = "SELECT platter_id FROM interests WHERE user_id = :user_id"
      where("id IN (#{followed_platter_ids})", user_id: user.id).order('last_platter_activity_at DESC')
  end

  def self.followed_platters_of(user)
      joins(:interests).where("platters.user_id = :user_id", user_id: user.id).uniq
  end
  
end
