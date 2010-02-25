class SessionsController < ApplicationController
  skip_before_filter :logged_in?, :only => [:login, :install]

  def login
    @session = Session.new(params[:session])
    if @session.username and @session.password
      member = Member.authenticate(@session.username, @session.password)
      if member and member.can_login?
	session[:member_id] = member.id
	redirect_back_or_to '/'
      else
	@session.errors.add(:base, "Bad username/password provided.")

	respond_to do |format|
	  format.html
	end
      end
    else
      respond_to do |format|
	format.html 
      end
    end
  end

  def logout
    reset_session
    redirect_to login_path
  end
end
