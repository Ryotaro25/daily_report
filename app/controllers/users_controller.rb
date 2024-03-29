class UsersController < ApplicationController

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :guest_user, only: [:edit, :destroy]


  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 6)
    @allpost = @user.microposts.all.first(3)
    @micropost = Micropost.find_by(id: params[:id])
  end

  def index
    #検索が実行された場合の条件分岐
    @users = if params[:search]
      User.paginate(page: params[:page]).where('name LIKE ?', "%#{params[:search]}%")
    else
     User.paginate(page: params[:page])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user =User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "プロフィールが編集されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントは削除されました"
    redirect_to root_url
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    #一旦使わない
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def guest_user
      if current_user == User.find_by(email: "guest@example.com")
      redirect_to root_url
      flash[:danger] = "機能が制限されております。"
      end 
    end
end
