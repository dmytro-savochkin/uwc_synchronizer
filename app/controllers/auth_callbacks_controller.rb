# encoding: utf-8
class AuthCallbacksController < ApplicationController
  require "omniauth-facebook"
  #require "omniauth-google-oauth2"
  require "omniauth-vkontakte"
  require "omniauth-twitter"
  require "omniauth-linkedin"

  include ClientLoginMethods



  def callback
    auth_data = request.env["omniauth.auth"]
    provider = auth_data.provider
    social_network_class = SocialNetwork.factory provider


    if social_network_class.create_oauth(provider, auth_data, current_user)
      flash[:success] = auth_data.provider + ' was linked with your account.'
      #@a = auth_data
      #render 'sync/index'
      redirect_to sync_path
    else
      flash[:error] = 'This ' + auth_data.provider + ' account is already taken by someone.'
      redirect_to sync_path
    end
  end






  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end