class Location < ActiveRecord::Base
  has_ancestry orphan_strategy: :restrict
  belongs_to :item, inverse_of: :location
  
  validates :item, presence: true
  validate :parent_must_be_a_location
  validate :must_be_a_location_if_have_children
  
  scope :location_tree, -> { includes(:item).order("items.name ASC") }
  
   def self.arrange_as_array(hash = nil)
    hash = arrange
    arr = []
    hash.each do |node, children|
      arr << node
      arr += arrange_as_array(children) unless children.empty?
    end
    arr
  end
  
  private
  def parent_must_be_a_location
    if self.parent
      if !self.parent.is_location
        errors.add(:parent_id, "must be a location")
      end
    end
  end
  
  def must_be_a_location_if_have_children
    if self.has_children? and !self.is_location
      errors.add(:is_location, "A thing can't have children")
    end
  end
  
end
