class EmailQueueTag < ActiveRecord::Base
  validates_presence_of :email
  validates_presence_of :email_queue

  belongs_to :email
  belongs_to :email_queue
end
