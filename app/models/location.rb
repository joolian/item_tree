class Location < ActiveRecord::Base
  has_ancestry orphan_strategy: :restrict
  belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  validate :parent_must_be_a_location
  scope :location_tree, -> { includes(:item).order("items.name ASC") }
  
  def parent_must_be_a_location
    if self.parent
      if !self.parent.is_location
        errors.add(:parent_id, "must be a location")
      end
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
  
end
