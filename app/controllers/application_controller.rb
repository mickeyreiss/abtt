# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  acts_as_iphone_controller

  before_filter :find_member, :logged_in?

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_hash

  def redirect_back_or_to(path)
    if session[:back]
      redirect_to session[:back]
    else
      redirect_to path
    end
  end

protected 
  def find_member
    @cur_member = Member.find_by_id(session[:member_id])
  end

  def logged_in?
    return true
    unless @cur_member and @cur_member.active?
      redirect_to login_path
    end
  end
end
