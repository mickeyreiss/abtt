class EmailQueuesController < ApplicationController
  layout "application2"

  def index
    @inbox = Email.unqueued
    @queues = EmailQueue.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def new
    @queue = EmailQueue.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @queue = EmailQueue.new(params[:email_queue])

    respond_to do |format|
      if @queue.save
        format.html { redirect_to email_queues_path }
      else
        flash[:error] = "There was an error saving the new queue."
        format.html { render :action => :new }
      end
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
