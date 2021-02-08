require 'rails_helper'

RSpec.describe "Comments", type: :request do
 

  describe "create comment" do
    context "login user" do
      let(:user) { FactoryBot.create(:user) }
      let(:micropost) { FactoryBot.create(:micropost)}
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
      end

      it "posts comment to micropost" do
        expect do
          post micropost_comments_path(micropost), params: {comment: {content: "comment"}}
        end.to change(Comment, :count).by(1)
      end

      it "is invalid post request with content nil" do
        expect do
          post micropost_comments_path(micropost), params: {comment: {content: nil}}
        end.to change(Comment, :count).by(0)
      end
    end

    context "user without login" do
      let(:micropost) { FactoryBot.create(:micropost)}
      it "is invalid request" do
          post micropost_comments_path(micropost), params: {comment: {content: "comment"}}
          expect(response).to have_http_status "302"
      end

      it "redirects to login url" do
        post micropost_comments_path(micropost), params: {comment: {content: "comment"}}
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "delete comment" do
    context "login user" do
      let(:user) { FactoryBot.create(:user) }
      let(:micropost) { FactoryBot.create(:micropost, user_id: user.id)}
      before(:each) do
        post login_path, params: { session: { name: user.name, email: user.email,
                                              password: user.password, password_confirmation: user.password} }
        @comment = FactoryBot.create(:comment, user_id: user.id, micropost_id: micropost.id)                                                                       
      end
      
      it "delete comment" do
        expect do
         @comment.destroy
        end.to change(Comment, :count).by(-1)
      end

    end

    context "user without login" do
      let(:user) { FactoryBot.create(:user) }
      let(:micropost) { FactoryBot.create(:micropost, user_id: user.id)}
      let(:comment) {FactoryBot.create(:comment)}
      
      it "redirects to root url" do
        delete micropost_comment_path(micropost, comment)
        expect(response).to redirect_to login_url
      end
    end
  end
end
