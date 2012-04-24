class Email < ActiveRecord::Base
  attr_accessible :content, :content_attachment

  validates_presence_of :content

  has_many :email_assignments, :dependent => :destroy
  has_many :email_flags, :dependent => :destroy

  # Returns subset of emails without any queue assignment
  def self.unqueued 
    find(:all).select { |e| e.email_queues.count == 0 }
  end

  def email_queues
    email_assignments.find(:all, :conditions => { :assignable_type => "EmailQueue" }).collect(&:assignable)
  end

  def content_attachment=(attachment)
    self.content = attachment.read unless attachment.empty?
  end

  def email
    @email ||= Mail.new(content)
  end

  def flags
    flags = [] 
    flags << "N" unless global_read
    flags << "F/U" if global_requires_follow_up
    flags << "B" if global_blocking
    flags << "C" if global_closed

    flags.join " "
  end

  def assignments
    assignments = []

    assignments << "E" if assigned_to? :event
    assignments << "Q" if assigned_to? :email_queue
    assignments << "M" if assigned_to? :member

    assignments.join " "
  end

  def new_response
    r = Response.new
    r.subject = self.subject
    r.from = "tracker@example.com"
    r.to = self.from
    r.cc = self.cc

    r
  end

  def assigned_to? some_type
    email_assignments.count(:all, :conditions => { :assignable_type => some_type.to_s.camelize }) != 0
  end

  #TODO: Refactor me using method_missing to delegate to email.email
  def from
    email.from
  end

  def to
    email.to
  end

  def cc
    email.cc
  end

  def bcc
    email.bcc
  end

  def date
    email.date
  end

  def subject
    email.subject
  end

  def body
    if email.multipart?
      if email.text_part
        email.text_part.body
      else
        email.html_part.body
      end
    else
      email.body
    end
  end

  def multipart?
    email.multipart?
  end

  def to_s
    "Email from #{from} to #{to} on #{date}"
  end

  def mark_as_read_by!(member)
    self.update_attribute :global_read, true
  end
end
