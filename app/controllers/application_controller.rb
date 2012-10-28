class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user



  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end




  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_404(exception = nil)
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
end
