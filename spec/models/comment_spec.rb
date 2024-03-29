require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:comment)).to be_valid
  end

  it "is invalid with no user_id" do
    comment = FactoryBot.build(:comment, user_id: nil)
      expect(comment).not_to be_valid
  end

  it "is invalid with no content" do
    comment = FactoryBot.build(:comment, content: nil)
      expect(comment).not_to be_valid
  end

  it "is invalid with content over 140" do
    comment = FactoryBot.build(:comment, content: "a" * 141)
      expect(comment).not_to be_valid
  end
end
