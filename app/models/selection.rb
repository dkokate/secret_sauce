class Selection < ActiveRecord::Base
  belongs_to :platter
  validates :platter_id, presence: true
  belongs_to :source_recipe
  validates :source_recipe_id, presence: true, uniqueness: {:scope => :platter_id }
end
