class EmailsController < ApplicationController
  layout 'application2'

  def index
    #TODO: Email filtering
    #TODO: Email pagination

    if params[:email_queue_id]
      @email_queue = EmailQueue.find(params[:email_queue_id])
      @emails = @email_queue.emails
    elsif params[:member_id]
      @member = Member.find(params[:member_id])
      @emails = @member.emails
    else
      @emails = Email.find(:all, :limit => 50)
    end

    @email_queues = EmailQueue.find(:all)
    @members_with_assignments = EmailAssignment.members_with_assignments

    respond_to do |format|
      format.html
    end
  end

  def show
    @email = Email.find(params[:id])
    @response = @email.new_response
    Email.new(:from => "tracker@abtech.example")

    @email.mark_as_read_by!(current_member)

    respond_to do |format|
      format.html
      format.text { render :layout => false }
    end
  end

  def new
    @email = Email.new

    respond_to do |format|
      format.html
      format.json { render :json => {} }
    end
  end

  def create
    @email = Email.new(params[:email])

    respond_to do |format|
      if @email.save
        format.html { redirect_to emails_path }
        format.json { render :json => {:email => @email}, :status => :unprocessable_entity }
      else
        format.html { render :action => :new }
        format.json { render :json => {:errors => @email.errors}, :status => :ok }
      end
    end
  end

  def edit
  end

  def update
  end
end
