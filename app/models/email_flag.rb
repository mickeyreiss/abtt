class EmailFlag < ActiveRecord::Base
  validates_presence_of :member_id, :email_id
  validates_associated :member

  validates_uniqueness_of :member_id

  belongs_to :member
  belongs_to :email

  def to_s
    flags = [] 
    flags << "n" unless read
    flags << "f/u" if requires_follow_up
    flags << "b" if blocking
    flags << "c" if closed

    flags.join " "
  end
end
