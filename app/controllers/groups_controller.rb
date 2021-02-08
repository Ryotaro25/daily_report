class GroupsController < ApplicationController
  before_action :logged_in_user
  
  def new
    @group = Group.new
  end


  def index
    @groups = Group.all
    @group = Group.find_by(id: params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = "グループを作成しました"
      redirect_to groups_path
    else
      flash[:danger] = "グループ名を入力してください"
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      flash[:success] = "グループ名が編集されました"
      redirect_to groups_path
    else
      redirect_to groups_path
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "グループを削除しました"
    redirect_to groups_path
  end

  #グループに参加する
  def join
    @group = Group.find_by(id: params[:id])
    if !@group.users.include?(current_user) && current_user.groups.count < 1
      @group.users << current_user
      redirect_to groups_path
    else
      flash[:danger] = "すでに所属しております。"
      redirect_to groups_path
    end
  end

  #グループから抜ける
  def leave
    @group = Group.find_by(id: params[:id])
    if @group.users.include?(current_user)
    @group.users.delete(current_user)
    redirect_to groups_path
    else
      flash[:danger] = "所属しておりません"
      redirect_to groups_path
    end
  end

  def alreadyjoin
    @group = Group.find_by(id: params[:id])
    @group.users.include?(current_user)
  end


  private
    def group_params
      params.require(:group).permit(:name, user_id: [] )
    end

end
