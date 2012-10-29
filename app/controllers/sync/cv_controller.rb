class Sync::CvController < ApplicationController
  def show
    @user = current_user
  end

  def upload
    @user = current_user
  end
end
