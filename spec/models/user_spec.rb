require 'rails_helper'

RSpec.describe User, type: :model do
  describe User do
  
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it "is invalid without a name" do
      user = FactoryBot.build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "is invalid without a name length under 51" do
      user = FactoryBot.build(:user, name: "a" * 51)
      expect(user).not_to be_valid
    end

    it "is invalid without a email" do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "is invalid without a email length under 255" do
      user = FactoryBot.build(:user, email: "a" * 244 + "@example.com")
      expect(user).not_to be_valid
    end

    it "is valid with a email has unique address" do
      user1 = FactoryBot.build(:user)
      user2 = FactoryBot.build(:user)
      expect(user2).to be_valid
    end

    it "is invalid with a blank password" do
      user = FactoryBot.build(:user, password: " " * 6)
      expect(user).not_to be_valid
    end

    it "is invalid with password length under 5" do
      user = FactoryBot.build(:user, password: "a" * 5)
      expect(user).not_to be_valid
    end

    it "reject invalid email adresses" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        user = FactoryBot.build(:user, email: invalid_address)
        expect(user).not_to be_valid
      end
    end

    it "authenticated? should return false for a user with nil digest" do
      user = FactoryBot.build(:user)
      user.authenticated?(' ')
      expect(user).to be_truthy
    end

  end
end
