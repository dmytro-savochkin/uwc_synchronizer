class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      flash[:success] = "You have succesfully logged in"
      redirect_to sync_path
    else
      flash.now[:error] = "Invalid data"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have succesfully logged out"
    redirect_to root_path
  end
end
