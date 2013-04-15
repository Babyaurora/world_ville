class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :friends, :attractions, :shops]
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
    @founder_list = @user.founder_of.paginate(page: params[:founder_page], per_page: 4)
    @mayor_list = @user.mayor_of.paginate(page: params[:mayor_page], per_page: 4)
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  def friends
    @title = "Friends"
    @user = User.find(params[:id])
    @users = @user.friends.paginate(page: params[:page])
    render 'show_relationship'
  end
  
  def attractions
    @title = "Attractions"
    @user = User.find(params[:id])
    @users = @user.attractions.paginate(page: params[:page])
    render 'show_relationship'
  end
  
  def shops
    @title = "Shops"
    @user = User.find(params[:id])
    @users = @user.shops.paginate(page: params[:page])
    render 'show_relationship'
  end
  
  # TODO: hardcoded house maker, should render user's own house
  def search
    @users = User.search(params[:location], params[:type])
    @json = @users.to_gmaps4rails do |user, marker|
      marker.infowindow render_to_string(partial: "/users/infowindow", locals: { user: user })
      marker.picture({
                  picture: ActionController::Base.helpers.asset_path("houses/house#{user.house_id+1}_small.jpg"),
                  width: 100,
                  height: 80
                 })
      marker.title "#{user.display_name}"
    end
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
