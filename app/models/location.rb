class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :restrict
	belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  scope :location_tree, -> {includes(:item)}
  
	def can_be_destroyed
		#if !self.item.organisation and self.is_childless?
    if self.is_childless? then
			return true
		else
			return false
		end
	end
  
  def self.text_search(query)
    if query.present? then
      location_tree.where( "items.name ilike :q", q: "%#{query}%"  ).references(:items)
    else
    end
  end
  
end
