require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "get new and create" do
    it "is valid sign up path" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it "is valid signup information" do
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

    it " is invalid signup information without name" do
      get signup_path
      expect {
        post users_path, params: { user: { name: " ", email: "user@invalid",
        password: "foo", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    it " is invalid signup information without email" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: " ",
        password: "foo", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    it "is invalid signup information without password" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: "user@invalid",
        password: " ", password_confirmation: "bar"}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end

    it " is invalid signup information without password confirmation" do
      get signup_path
      expect {
        post users_path, params: { user: { name: "Example user", email: "user@invalid",
        password: "foo", password_confirmation: ""}}
        }.to_not change(User, :count)
        expect(response).to render_template('users/new')
    end
  end

  describe "get login" do
    it "is valid login path" do
      get login_path
      expect(response).to have_http_status(:success)
    end

    it "is valid login information" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: user.password, password_confirmation: user.password} }
      expect(is_logged_in?).to be_truthy
    end
    
    it "is invalid login information with invalid email" do
      post login_path, params: { session: { name: " ", email: " ",
                                            password: user.password, password_confirmation: user.password} }
      expect(flash[:danger]).to be_truthy
    end

    it "is invalid login information with invalid password" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: " ", password_confirmation: user.password} }
      expect(flash[:danger]).to be_truthy
    end

    it " is invalid login information with invalid password confirmation" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: user.email, password_confirmation: " "} }
      expect(flash[:danger]).to be_truthy
    end

    it "is valid request to logout" do
      post login_path, params: { session: { name: user.name, email: user.email,
                                            password: user.password, password_confirmation: user.password} }
      delete logout_path
      expect(response).to redirect_to root_path
    end

    it "is valid request to logout" do
      delete logout_path
      expect(session[:user_id]).to eq nil
    end
  end

  describe "Get index" do
    context "as a corect user" do
      before(:each) do
        @user = FactoryBot.create(:user, name: "Takeshi")
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get users_path
        expect(response.status).to eq 200
      end

      it "shows other user's name" do
        get users_path(@user)
        expect(response.body).to include "Takeshi"
      end
    end

    context "as a user without login" do
      it "returns a 302 responce" do
        get users_path
        expect(response.status).to eq 302
      end

      it "redirects to login url witout login" do
        get users_path
        expect(response).to redirect_to login_url
      end 
    end
  end

  describe "Get show" do
    context "user with login" do
      before(:each) do
        @user2 = FactoryBot.create(:user) 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get user_path(user)
        expect(response.status).to eq 200
      end

      it "is valid access to other user" do
        get user_path(@user2)
        expect(response.status).to eq 200
      end
    end

    context "user witout login" do
      it "doesn't access show" do
        get user_path(user)
        expect(response.status).to eq 302
      end 

      it "redirects to login url witout login" do
        get user_path(user)
        expect(response).to redirect_to login_url
      end 
    end
  end

  describe "Get edit" do
    context "user with login" do
      before(:each) do
        @user2 = FactoryBot.create(:user) 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get edit_user_path(user)
        expect(response.status).to eq 200
      end

      it "is invalid request" do
        get edit_user_path(@user2)
        expect(response.status).to eq 302
      end

      it "redirects to root url when access to another user" do
        get edit_user_path(@user2)
        expect(response).to redirect_to root_path
      end
    end

    context "user witout login" do
      it "doesn't access edit" do
        get edit_user_path(user)
        expect(response.status).to eq 302
      end 

      it "redirects to root ulr without login" do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
      end
    end

  end

  describe "Update users" do
    context "user with login" do
      before(:each) do
        
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid update changing name" do
        user_params = FactoryBot.attributes_for(:user, name: "keisuke")
        patch user_path(user), params: {user: user_params}
        expect(user.reload.name).to eq "keisuke"
      end

      it "is invalid update with name blank" do
        user_params = FactoryBot.attributes_for(:user, name: " ")
        patch user_path(user), params: {user: user_params}
        expect(user.reload.name).to eq "Michael"
      end

      it "is invalid update with email blank" do
        user_params = FactoryBot.attributes_for(:user, email: " ")
        patch user_path(user), params: {user: user_params}
        expect(response).to render_template :edit
      end

      it "redirect to edit page with invalid user name" do
        user_params = FactoryBot.attributes_for(:user, name: " ")
        patch user_path(user), params: {user: user_params}
        expect(response).to render_template :edit
      end

      it "redirect to edit page with invalid user name" do
        user_params = FactoryBot.attributes_for(:user, name: "a" * 51)
        patch user_path(user), params: {user: user_params}
        expect(response).to render_template :edit
      end

      it "is valid update changing email" do
        user_params = FactoryBot.attributes_for(:user, email: "update@example.com")
        patch user_path(user), params: {user: user_params}
        expect(user.reload.email).to eq "update@example.com"
      end

    end

    context "user with logout" do
      it "is invalid witout logout" do
        user_params = FactoryBot.attributes_for(:user, name: "keisuke")
        patch user_path(user), params: {user: user_params}
        expect(response.status).to eq 302
      end

      it "redirects login url" do
        user_params = FactoryBot.attributes_for(:user, name: "keisuke")
        patch user_path(user), params: {user: user_params}
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "Delete users" do
    context "user with login" do
      before(:each) do
        @user2 = FactoryBot.create(:user) 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid access" do
        expect do
          delete user_path(user), params: { id: user.id }
        end.to change(User, :count).by(-1)
      end

      it "is invalid delete access" do
        expect do
          delete user_path(@user2), params: { id: user.id }
        end.to change(User, :count).by(0)
      end
    end

    context "user without login" do
      it "returns a 302 response" do
        delete user_path(user), params: { id: user.id }
        expect(response).to have_http_status "302"
      end

      it "is invalid request" do
        delete user_path(user), params: { id: user.id }
        expect(response).to redirect_to login_url
      end
    end
  end
end
