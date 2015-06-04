class Item < ActiveRecord::Base
	has_one :location, dependent: :destroy, inverse_of: :item
  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
end
