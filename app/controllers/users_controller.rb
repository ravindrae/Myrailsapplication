class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update,:followers,:following]
  before_action :find_user ,only: [:edit,:show,:update,:destroy]
  before_action :correct_user,only:[:edit,:update]
  include SessionsHelper
  def new
    @user=User.new
  end
  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit

  end
  def create
    @user=User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success]="An account activation link has been sent to your mail. "
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update

      if @user.update_attributes(user_params)
        flash[:success]="Profile updated."
        redirect_to @user
      else
        render 'edit'
      end
  end

  def destroy
    @user.destroy
   redirect_to users_path
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

  def correct_user
     unless @user == current_user
        flash[:danger]="Don't perform this action."
        redirect_to root_path
      end
  end

  def find_user
    @user=User.find(params[:id])
  end

  def admin_user
    if !current_user.admin?
      redirect_to root_path
    end
  end

end
