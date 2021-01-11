require 'rails_helper'

RSpec.describe Group, type: :model do
  it "is valid group with group name" do
    group = Group.new(name: "group sample")
    expect(group).to be_valid
  end

  it "is invalid group with group name" do
    group = Group.new(name: " ")
    expect(group).not_to be_valid
  end
end
