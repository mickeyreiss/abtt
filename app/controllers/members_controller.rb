class MembersController < ApplicationController
  def index
    @order = "first_name"
    @members = Member.all :order => "first_name"

    respond_to do |format|
      format.html
    end
  end

  def new
    @member = Member.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @member = Member.new(params[:member])

    respond_to do |format|
      if @member.save
	format.html
      else
	format.html { render new_member_path }
      end
    end
  end

  def show
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def edit
    @member = Member.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @member = Member.find(params[:id])

    respond_to do |format|
      if @member.update_atributes(params[:member])
	flash[:notice] = "Member #{params[:id]} updated."
	format.html { redirect_to members_path }
	format.xml { head :ok }
      else
	flash[:error] = "Member #{params[:id]} had errors."
	format.html { render edit_member_path } 
	format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    Member.destroy(params[:id])
    flash[:notice] = "Member #{params[:id]} deleted."

    respond_to do |format|
      format.html { redirect_to members_path }
      format.xml { head :ok } 
    end
  end

end
