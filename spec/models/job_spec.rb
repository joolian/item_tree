require 'rails_helper'

RSpec.describe Job, type: :model do
  it "has a valid factory" do
   #job =  FactoryGirl.create(:job)
    expect(FactoryGirl.create(:job)).to be_valid
  end
  it "is not valid without a description" do
    job = FactoryGirl.build(:job, description: nil)
    expect(job).not_to be_valid
  end
  it "is not valid without an item_id" do
    job = FactoryGirl.build(:job, item_id: nil)
    expect(job).not_to be_valid
  end  
end
