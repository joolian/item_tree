class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :rootify
	belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  scope :location_tree, -> {includes(:item).order("items.name ASC")}
  
  def self.arrange_as_array(hash = nil)
    hash = arrange
    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(children) unless children.empty?
    end
    arr
  end
  
end
