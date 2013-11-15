class SourceRecipe < ActiveRecord::Base
  has_many :selections, dependent: :destroy
end
