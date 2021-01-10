require 'rails_helper'

RSpec.describe Micropost, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid with no user_id" do
    micropost = FactoryBot.build(:micropost, user_id: nil)
      expect(micropost).not_to be_valid
  end

  it "is invalid with no content" do
    micropost = FactoryBot.build(:micropost, content: nil)
      micropost.valid?
      expect(micropost.errors[:content]).to include("を入力してください")
  end

  it "is invalid with no title" do
    micropost = FactoryBot.build(:micropost, title: nil)
      micropost.valid?
      expect(micropost.errors[:title]).to include("を入力してください")
  end

  it "is invalid with no start_time" do
    micropost = FactoryBot.build(:micropost, start_time: nil)
      micropost.valid?
      expect(micropost.errors[:start_time]).to include("を入力してください")
  end

  it "is invalid wiht no finish_time" do
    micropost = FactoryBot.build(:micropost, start_time: nil)
      micropost.valid?
      expect(micropost.errors[:start_time]).to include("を入力してください")
  end

  it "is invalid with title length over 20" do
    micropost = FactoryBot.build(:micropost, title: "a" * 21)
    expect(micropost).not_to be_valid
  end


  it "is invalid with content length over 140" do
    micropost = FactoryBot.build(:micropost, content: "a" * 141)
    expect(micropost).not_to be_valid
  end

  it "is valid with image which is jpeg or png" 
  it "is valid with image size under 5mb"
  it "is invalid with image which is not jpeg or png"
  it "is invalid with image size over 5mb"

end
