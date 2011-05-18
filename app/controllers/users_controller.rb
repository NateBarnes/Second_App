class UsersController < ApplicationController
  before_filter :authenticate,    :only => [:index, :edit, :update]
  before_filter :unauthenticated, :only => [:new, :create]
  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => :destroy
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def edit
    @title = "Edit user"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      render "new"
    end
  end
  
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    u = User.find(params[:id])
    if current_user != u
      u.destroy
      flash[:success] = "User destroyed"
      redirect_to users_path
    else
      flash[:error] = "You cannot delete yourself"
      redirect_to users_path
    end
  end
  
private
  def authenticate
    deny_access unless signed_in?
  end
  
  def unauthenticated
    deny_access if signed_in?
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
  def admin_user
    if current_user
      redirect_to(root_path) unless current_user.admin?
    else
      redirect_to(signin_path)
    end
  end
end
