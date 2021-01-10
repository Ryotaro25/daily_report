require 'rails_helper'

RSpec.describe Micropost, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end
