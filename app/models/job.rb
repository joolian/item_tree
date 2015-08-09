class Job < ActiveRecord::Base
  belongs_to :item
  validates :description, presence: true
  validates :item, presence: true
end
