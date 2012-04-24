class EmailQueue < ActiveRecord::Base
  validates_presence_of :title

  has_many :email_assignments, :as => :assignable, :dependent => :destroy
  has_many :emails, :through => :email_assignments

  def message_count
    emails.size
  end

  def unread_count
  end

  def global_unread_count
    emails.count(:all, :conditions => { :global_read => false } )
  end

  def to_s
    "#{title} queue"
  end
end
