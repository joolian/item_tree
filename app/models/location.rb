class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :restrict
	belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  scope :location_tree, -> {includes(:item)}
  
  def self.text_search(query)
    if query.present? then
      location_tree.where( "items.name ilike :q", q: "%#{query}%"  ).references(:items)
    else
    end
  end
  
end
