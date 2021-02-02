require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user_id: user.id) }

  describe "get create" do
    context "login user" do
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "posts micropost successfully" do
        expect do
        post microposts_path, params: { micropost: {content: "content", image: nil, title: "title", start_time:"2020-01-01 12:00:00", finish_time: "2020-01-01 12:00:00"} }
        end.to change(Micropost, :count).by(1)
      end

      it "doesn't post without content" do
        expect do
        post microposts_path, params: { micropost: {content: nil, image: nil, title: "title", start_time:"2020-01-01 12:00:00", finish_time: "2020-01-01 12:00:00"} }
        end.to change(Micropost, :count).by(0)
      end

      it "doesn't post without title" do
        expect do
        post microposts_path, params: { micropost: {content: "content", image: nil, title: nil, start_time:"2020-01-01 12:00:00", finish_time: "2020-01-01 12:00:00"} }
        end.to change(Micropost, :count).by(0)
      end

      it "doesn't post without start time" do
        expect do
        post microposts_path, params: { micropost: {content: "content", image: nil, title: "title", start_time: nil, finish_time: "2020-01-01 12:00:00"} }
        end.to change(Micropost, :count).by(0)
      end

      it "doesn't post without finish time" do
        expect do
        post microposts_path, params: { micropost: {content: "content", image: nil, title: "title", start_time: "2020-01-01 12:00:00", finish_time: nil} }
        end.to change(Micropost, :count).by(0)
      end
    end

    context "create without login" do
      it "doesn't post micropost without login" do
        expect do
          post microposts_path, params: { micropost: {content: "content", image: nil, title: "title", start_time:"2020-01-01 12:00:00", finish_time: "2020-01-01 12:00:00"} }
        end.to change(Micropost, :count).by(0)
      end

      it "is invalid request" do
        post microposts_path, params: { micropost: {content: "content", image: nil, title: "title", start_time:"2020-01-01 12:00:00", finish_time: "2020-01-01 12:00:00"} }
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "get show" do
    context "login user" do
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get micropost_path(micropost)
        expect(response).to have_http_status "200"
      end
    end

    context "user without login" do
      it "is invalid request" do
        get micropost_path(micropost)
        expect(response).to have_http_status "302"
      end

      it "redirects to login url" do
        get micropost_path(micropost)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "get edit" do
    context "login user" do
      before do 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "is valid request" do
        get edit_micropost_path(micropost)
        expect(response).to have_http_status "200"
      end
    end

    context "user without login" do
      it "is invalid request " do
        get edit_micropost_path(micropost)
        expect(response).to have_http_status "302"
      end
    end
  end

  describe "get update" do
    context "login user" do
      before do 
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "updates micropost content" do
        micropost_params = FactoryBot.attributes_for(:micropost, content: "test")
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(micropost.reload.content).to eq "test"
      end

      it "updates micropost content" do
        micropost_params = FactoryBot.attributes_for(:micropost, title: "test")
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(micropost.reload.title).to eq "test"
      end

      it "render edit with no content" do
        micropost_params = FactoryBot.attributes_for(:micropost, content: " ")
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(response).to render_template :edit
      end

      it "render editt with content over 140" do
        micropost_params = FactoryBot.attributes_for(:micropost, content: "a" * 141)
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(response).to render_template :edit
      end

      it "render edit with no ctitle" do
        micropost_params = FactoryBot.attributes_for(:micropost, title: " ")
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(response).to render_template :edit
      end

      it "render editt with title over 20" do
        micropost_params = FactoryBot.attributes_for(:micropost, title: "a" * 21)
        patch micropost_path(micropost), params: {micropost: micropost_params}
        expect(response).to render_template :edit
      end
    end
  end

  describe "get destroy" do
    context "login user" do
      context "login user" do
        let(:micropost) { FactoryBot.create(:micropost) }
        before do 
          post login_path, params: { session: { name: user.name, email: user.email,
                                                password: user.password, password_confirmation: user.password} }            
        end

        it "deletes post successfully" do
          expect do
          delete micropost_path(micropost)
          end.to change(Micropost, :count).by(1)
        end 
      end
    end

    context "user without login" do
      let(:micropost) { FactoryBot.create(:micropost) }

      it "redirect to root url without login" do
        delete micropost_path(micropost)
        expect(response).to redirect_to login_url
      end

      it "is invalid request" do
        delete micropost_path(micropost)
        expect(response).to have_http_status "302"
      end
    end
  end
end
