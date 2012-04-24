class PhonecallsController < ApplicationController
  layout "application2"

  def new
    @phonecall = Email.new
  end

  def create
    mail = Mail.new
      mail.from params[:phonecall][:phonenumber]
      mail.to "Incoming Phonecall"
      mail.subject params[:phonecall][:subject]
      mail['X-Phone-Number'] = params[:phonecall][:phonenumber]

      mail.body params[:phonecall][:body]

    @email = Email.new(:content => mail.encoded)

    if @email.save
      redirect_to @email
    else
      flash[:error] = "Could not save new phonecall: #{@email.errors.full_messages}"
      render :action => :new
    end
  end
end
