require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "users_signup_path" do
    it "is valid sign up path" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    example "valid signup information" do
      get signup_path
      expect {
        post users_path, params: { user: { name:  "Example User",
                                          email: "user@example.com",
                                          password:              "password",
                                          password_confirmation: "password" } }
        }.to change(User, :count).by(1)
      
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to be_truthy
    end

    example "invalid signup information without name" do
      get signup_path
      expect {
        post users_path, params: { user: { name: " ", email: "user@invalid",
        password: "foo", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    example "invalid signup information without email" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: " ",
        password: "foo", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    example "invalid signup information without password" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: "user@invalid",
        password: " ", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    example "invalid signup information without password confirmation" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: "user@invalid",
        password: "foo", password_confirmation: ""}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end
  end

  describe "users_login_path" do
    let(:user) { FactoryBot.create(:user) }

    it "is valid login path" do
      get login_path
      expect(response).to have_http_status(:success)
    end

    example "valid login information" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: user.password, password_confirmation: user.password} }
      expect(is_logged_in?).to be_truthy
    end
    
    example "invalid login information with invalid email" do
      post login_path, params: { session: { name: " ", email: " ",
                                            password: user.password, password_confirmation: user.password} }
      expect(flash[:danger]).to be_truthy
    end

    example "invalid login information with invalid password" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: " ", password_confirmation: user.password} }
      expect(flash[:danger]).to be_truthy
    end

    example "invalid login information with invalid password confirmation" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: user.email, password_confirmation: " "} }
      expect(flash[:danger]).to be_truthy
    end
  end


end
