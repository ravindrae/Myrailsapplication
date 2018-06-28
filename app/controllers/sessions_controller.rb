class SessionsController < ApplicationController
  def new
  end

  #Session creation
  def create
    user = User.find_by(email: params[:session][:email].downcase)
     if user && user.authenticate(params[:session][:password])
       if user.activated?
         log_in user
         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
         redirect_to user
       else
         message  = "Account not activated. "
         message += "Check your email for the activation link."
         flash[:danger] = message
         redirect_to root_url
       end

     else
       flash[:alert] = 'Invalid email/password combination'
       render 'new'
     end
  end

#Session destroy
  def destroy
    log_out if logged_in?
    flash[:success] = 'Successfully logged out.'
    redirect_to root_path
  end
end
