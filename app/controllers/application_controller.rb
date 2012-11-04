class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  rescue_from Twitter::Error::TooManyRequests, :with => :twitter_limit_exceeded


  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end



  protected

  def factory(provider)
    ('Social::Networks::' + provider.camelize).constantize
  rescue NameError
    ('Social::Clouds::' + provider.camelize).constantize
  end

  def twitter_limit_exceeded
    flash[:error] = 'Twitter API limit exceeded. Please wait some time and then try again.'
    redirect_to sync_path
  end


  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_404(exception = nil)
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
