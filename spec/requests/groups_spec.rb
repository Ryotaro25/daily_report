require 'rails_helper'

RSpec.describe "Groups", type: :request do
  context "create group" do
    context "login user" do
      let(:user) { FactoryBot.create(:user) }
      before(:each) do
        @user2 = FactoryBot.create(:user) 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end
      it "creates group" do
        expect do
        post groups_path, params: { group: { name: "grouptest"}}
        end.to change(Group, :count).by(1)
      end

      it "doesn't creates group without name" do
        expect do
        post groups_path, params: { group: { name: " "}}
        end.to change(Group, :count).by(0)
      end
    end

    context "user without login" do
      it "doesn's creates group" do  
        post groups_path, params: { group: { name: "grouptest"}}
        expect(response).to redirect_to login_url
      end
    end
  end

  context "get index" do
    context "login user" do
      let(:user) { FactoryBot.create(:user) }
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get groups_path
        expect(response).to have_http_status "200"
      end
    end
    context "user without login" do
      it "is invalid request" do
       get groups_path
       expect(response).to redirect_to login_url
      end
    end
  end

  context "edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) {FactoryBot.create(:group)}
    context "login user" do
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get edit_group_path(group)
        expect(response).to have_http_status "200"
      end      
    end

    context "user wihtout login" do
      it "is invalid request" do
        get edit_group_path(group)
        expect(response).to have_http_status "302"
      end
      it "redirects to login url" do
        get edit_group_path(group)
        expect(response).to redirect_to login_url  
     end
    end
  end

  context "update" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) {FactoryBot.create(:group)}
    context "login user" do
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "updates group name" do
        group_params = FactoryBot.attributes_for(:group, name: "test")
        patch group_path(group), params: {group: group_params}
        expect(group.reload.name).to eq "test"
      end

      it "redirects to group path with invalid request" do
        group_params = FactoryBot.attributes_for(:group, name: " ")
        patch group_path(group), params: {group: group_params}
        expect(response).to redirect_to groups_path 
      end
    end

    context "user wihtout login" do
      it "is invalid request" do
        group_params = FactoryBot.attributes_for(:group, name: "test")
        patch group_path(group), params: {group: group_params}
        expect(response).to have_http_status "302"
      end

      it "redirects to login url" do
        group_params = FactoryBot.attributes_for(:group, name: "test")
        patch group_path(group), params: {group: group_params}
        expect(response).to redirect_to login_url 
      end
    end

  end

  context "destroy" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) {FactoryBot.create(:group)}
    
    context "login user" do
      before do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
        @group = FactoryBot.create(:group)
      end

      it "deletes group successfully" do
        expect do
          @group.destroy
        end.to change(Group, :count).by(-1)
      end
    end

    context "user wihtout login" do
      it "redirects to root url without login" do
        delete group_path(group)
        expect(response).to redirect_to login_url
      end
    end
  end

  context "join and leave" do
    let(:user) { FactoryBot.create(:user) }
    let(:group) {FactoryBot.create(:group, user_id: user.id)}
    
    context "login user" do
      before do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end
    end
  end
end
