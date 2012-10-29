class Sync::WelcomeController < ApplicationController
  def index
    @user = current_user
  end
end
