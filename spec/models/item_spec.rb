require 'rails_helper'

RSpec.describe Item, type: :model do
it "has a valid factory"
it "is invalid without a name"
it "is invalid without a unique code"
it "is invalid without a location"
it "can only have one root location"
it "returns the root location"
it "returns if a location path is continuous"
it "An empty search string returns nothing"
it "A search string returns an array of scoped locations"
it "does not allow the root item to be deleted"
it "does not allow an item with children to be deleted"
it "returns an array of ancestors"


end