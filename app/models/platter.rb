class Platter < ActiveRecord::Base
  belongs_to :user
  has_many :selections, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }
end
