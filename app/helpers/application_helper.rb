# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def environment_notice 
    '<div style="float: left; font-size: 20pt; background-color: black; color: red;">#{ENV["RAILS_ENV"].upcase} <br />ENVIRONMENT</div>' if ENV["RAILS_ENV"] == 'development'
  end
end
