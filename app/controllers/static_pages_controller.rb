class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 6)
    end
    @pie_chart = Group.joins(users: :microposts).group("name").count
  end
end
