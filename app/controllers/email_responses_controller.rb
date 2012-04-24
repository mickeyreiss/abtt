class EmailResponsesController < ApplicationController
  def create

    @email = Email.find(params[:email_id])
    @response = Email.new(params[:respose])

    if @email.save
      redirect_to @email
    else
      render @email
    end
  end
end
