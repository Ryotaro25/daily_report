class GroupsController < ApplicationController
  
  def new
    @group = Group.new
    @group.users << current_user
  end


  def index
    @groups = Group.all
    @group = Group.find_by(id: params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.users << current_user
      flash[:success] = "グループを作成しました"
      redirect_to groups_path
    else
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
      render 'edit'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "グループを削除しました"
    redirect_to groups_path
  end

  private
  def group_params
    params.require(:group).permit(:name, user_id: [] )
  end

end
