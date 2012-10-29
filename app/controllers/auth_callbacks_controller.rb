# encoding: utf-8
class AuthCallbacksController < ApplicationController
  #include Social



  def callback
    auth_data = request.env["omniauth.auth"]
    oauth_provider = auth_data.provider
    oauth_provider_class = factory(oauth_provider)
    oauth_instance = oauth_provider_class.create_oauth(auth_data, current_user)
    if oauth_instance

      logger.info oauth_provider_class
      logger.info oauth_provider_class < Social::Cloud
      logger.info current_user.preferred_cloud
      logger.info current_user.preferred_cloud.nil?
      if oauth_provider_class < Social::Cloud and current_user.preferred_cloud.nil?
        logger.info "131231231231313"
        current_user.preferred_cloud = oauth_instance
      end


      flash[:success] = auth_data.provider + ' was linked with your account.'
      redirect_to sync_path
    else
      flash[:error] = 'This ' + auth_data.provider.to_s + ' account is already taken by someone.'
      redirect_to sync_path
    end
  end


  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end



  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end