class EmailAssignmentsController < ApplicationController
  layout "application2"

  before_filter :prepare_instance_variables

  def new
    @email_assignment = EmailAssignment.new(:email => @email, :assigner => @cur_member)
  end

  def create
    @email_assignment = EmailAssignment.new(params[:email_assignment])
    @email_assignment.assigner_id = current_member.id
    @email_assignment.email_id = @email.id

    respond_to do |format|
      if @email_assignment.save
        format.html { redirect_to email_path(@email_assignment.email) }
      else
        format.html { render :action => :new }
      end
    end
  end

  def destroy
    @email = Email.find(params[:email_id])

    @email.email_assignments.destroy(params[:id])
    flash[:notice] = "Assignment has been deleted."

    respond_to do |format|
      format.html { redirect_to @email }
    end
  end

private
  def prepare_instance_variables
    @members = Member.find(:all)
    @emails = Email.find(:all)
    @email_queues = EmailQueue.find(:all)
    @events = Event.find(:all)

    @email = Email.find(params[:email_id])
  end
end
