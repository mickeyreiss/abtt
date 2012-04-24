class EmailAssignment < ActiveRecord::Base
  belongs_to :email
  belongs_to :assigner, :class_name => "Member"
  belongs_to :assignable, :polymorphic => true

  # Caution: fake association, requires a condition on assignable_type
  belongs_to :member, :foreign_key => :assignable_id

  validates_presence_of :email_id, :assigner_id, :assignable_id, :assignable_type

  validates_associated :assigner, :assignable, :email

  attr_accessible :email_id, :assigner_id, :assignable_id, :assignable_type

  def to_s
    "Assigned to #{assignable} by #{assigner} on #{created_at}"
  end

  def self.members_with_assignments
    find(:all, :conditions => { :assignable_type => "Member" }).collect(&:member)
  end
end
