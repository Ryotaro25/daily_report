require 'rails_helper'

RSpec.describe Like, type: :model do
  it "is valid like with userid and micropost_id" do
    expect(FactoryBot.build(:like)).to be_valid
  end

  it "is invalid with no user_id" do
    like = FactoryBot.build(:like, user_id: nil)
      expect(like).not_to be_valid
  end

  it "is invalid with no micropost_id" do
    like = FactoryBot.build(:like, micropost_id: nil)
      expect(like).not_to be_valid
  end
end
