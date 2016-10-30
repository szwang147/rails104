

class GroupsController < ApplicationController
    before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
    before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]


  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end
  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end
  def edit

  end
  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end
  def update


    if @group.update(group_params)
      redirect_to groups_path, notice: 'ur up boy'
    else
      render :edit
    end
  end
  def destroy

    @group.destroy
    redirect_to groups_path, alert: 'ur destroy boy'
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = '加入本论坛成功'
    else
      flash[:warning] = '你已经是本论坛的成员了'
    end
    redirect_to group_path(@group)
  end

     def quit
       @group = Group.find(params[:id])
       if current_user.is_member_of?(@group)
         current_user.quit!(@group)
         flash[:alert] = "已经退出本版，洗洗睡吧"
       else
         flash[:warning] = "你是过来找抽的么"
       end
       redirect_to group_path(@group)
     end






  private
  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: 'you have no door'
    end
  end

  def group_params
params.require(:group).permit(:title, :description)
end
end
