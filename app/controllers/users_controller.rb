class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :senders, :receivers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:index, :destroy]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @stories = @user.own_stories.paginate(page: params[:page])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  def senders
    @title = "Senders"
    @user = User.find(params[:id])
    @users = @user.senders.paginate(page: params[:page])
    render 'show_relationship'
  end

  def receivers
    @title = "Receivers"
    @user = User.find(params[:id])
    @users = @user.receivers.paginate(page: params[:page])
    render 'show_relationship'
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
