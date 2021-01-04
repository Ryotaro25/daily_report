class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:destroy, :edit]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "日報が投稿されました"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 6)
      render 'static_pages/home'
    end
  end

  #投稿の編集を行う
  def edit
    @micropost = Micropost.find_by(id: params[:id])
  end

  def update
    @micropost = Micropost.find_by(id: params[:id])
    if @micropost.update(micropost_params)
      flash[:success] = "日報が編集されました"
      redirect_to @micropost
    else
      render 'edit'
    end
  end

  #投稿の詳細を表示
  def show
    @micropost = Micropost.find_by(id: params[:id])
    @user = User.find_by(params[:id])
    @comment = Comment.new
    @comments = @micropost.comments
  end

  def destroy
    @micropost.destroy
    flash[:success] = "日報は削除されました。"
    redirect_to root_url
  end

 

  private
    
    def micropost_params
      params.require(:micropost).permit(:content, :image, :title, :start_time, :finish_time)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
