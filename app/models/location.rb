class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :restrict
	belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  scope :location_tree, -> {includes(:item)}
end
