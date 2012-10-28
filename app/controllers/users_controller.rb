class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create params[:user]

    if @user.save
      session[:user_id] = user.id
      flash[:success] = 'You have registered'
      redirect_to sync_path
    else
      flash.now[:error] = 'Some error occured'
      render :new
    end
  end


end
