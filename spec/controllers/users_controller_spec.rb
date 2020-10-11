require 'rails_helper'

RSpec.describe UsersController, type: :request do

  describe "#new" do
    it "responds successfully" do
      get signup_path
      expect(response).to be_successful
    end
  end

  describe "#index" do
    it "responds unsuccessfully" do
      get users_path
      expect(response).to_not be_successful
    end
  end
end
