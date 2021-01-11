class ApplicationController < ActionController::Base
  include SessionsHelper

  private

    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
    end

    #機能制限を定義
    def guest_user
      @user = User.find_by(email: 'guest@example.com')
      if @user == current_user
          flash[:danger] = 'ユーザーの編集は制限されております。'
          redirect_to root_url
      end
end
end
