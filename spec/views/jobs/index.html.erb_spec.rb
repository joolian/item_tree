require 'rails_helper'

RSpec.describe "jobs/index", type: :view do
  before(:each) do
    assign(:jobs, [
      Job.create!(),
      Job.create!()
    ])
  end

  it "renders a list of jobs" do
    render
  end
end
