class Location < ActiveRecord::Base
	has_ancestry orphan_strategy: :restrict
	belongs_to :item, inverse_of: :location
end
