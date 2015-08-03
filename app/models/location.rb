class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :rootify, cache_depth: true
	belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  scope :location_tree, -> {includes(:item).order("items.name ASC")}
  
	def can_be_destroyed
		#if !self.item.organisation and self.is_childless?
    if self.is_childless? then
			return true
		else
			return false
		end
	end
  
  def self.arrange_as_array(hash = nil)
    hash = arrange
    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(children) unless children.empty?
    end
    arr
  end
  
  def self.text_search(query)
    if query.present? then
      location_tree.where( "items.name ilike :q", q: "%#{query}%"  ).references(:items)
    else
    end
  end
  
end
