class Event < ActiveRecord::Base
  has_many                :eventdates, :dependent => :destroy, :order => "startdate ASC";
  has_many                :event_roles, :dependent => :destroy;
  has_many                :invoices, :dependent => :destroy;
  has_many                :journals;		
  belongs_to              :organization;
  belongs_to              :year;

  has_many                :attachments

  has_many :email_assignments, :as => :assignable, :dependent => :destroy
  has_many :emails, :through => :email_assignments
  
  EmailRegex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/;
  PhoneRegex = /^[0-9]{3}-[0-9]{3}-[0-9]{4}$/;
  
  Event_Status_Tentative_Date     = "Tentative Date";
  Event_Status_Initial_Request    = "Initial Request";
  Event_Status_Details_Requested  = "Details Requested";
  Event_Status_Quote_Sent         = "Quote Sent";
  Event_Status_Event_Confirmed    = "Event Confirmed";
  Event_Status_Billing_Pending	  = "Billing Pending";
  Event_Status_Event_Completed    = "Event Completed";
  Event_Status_Event_Declined     = "Event Declined";
  Event_Status_Event_Cancelled    = "Event Cancelled";
  
  Event_Status_Group_Completed = [Event_Status_Event_Completed,
                                  Event_Status_Event_Cancelled,
                                  Event_Status_Event_Declined]
  
  Event_Status_Group_All = [Event_Status_Tentative_Date,
                            Event_Status_Initial_Request,
                            Event_Status_Details_Requested,
                            Event_Status_Quote_Sent,
                            Event_Status_Event_Confirmed,
			    Event_Status_Billing_Pending,
                            Event_Status_Event_Completed,
                            Event_Status_Event_Declined,
                            Event_Status_Event_Cancelled]

  Event_Status_Group_Not_Cancelled = [Event_Status_Tentative_Date,
                            Event_Status_Initial_Request,
                            Event_Status_Details_Requested,
                            Event_Status_Quote_Sent,
                            Event_Status_Event_Confirmed,
			    Event_Status_Billing_Pending,
                            Event_Status_Event_Completed]

  Event_Status_Group_Cancelled = [Event_Status_Event_Cancelled];

  Event_Status_Group_Declined  = [Event_Status_Event_Declined];

  validates_presence_of     :title, :status, :organization, :eventdates
  validates_inclusion_of    :status, :in => Event_Status_Group_All;
  validates_associated      :organization, :event_roles, :eventdates;
  validates_format_of       :contactemail, :with => Event::EmailRegex;

  def locations
    locs = [];

    eventdates.each do |date|
        locs = locs | date.locations;
    end

    return locs;
  end

  # return an array of dates segmenting regions of dates.
  def date_regions
    times = eventdates.collect{|dt| [dt.startdate, dt.enddate]}.flatten().uniq().sort();
    dates = eventdates().sort_by{|k| k.startdate};

    contents = [];
    working_set = [];
    headers = [];

    times.each do |time|
        working_set.reject! {|date| !((date.startdate <= time) && (date.enddate > time))};

        while(!dates.empty? && (dates.first.startdate <= time) && (dates.first.enddate > time))
            working_set << dates.shift();
        end
    
        if(!working_set.empty?)
            headers << time;
            contents << Array.new(working_set);
        end
    end

    return headers, contents;
  end

  # method to resort event_roles by a given key
  # @param by is a field of event_role, but this behavior is not yet implemented
  def sort_roles
    event_roles.sort!
  end

  def approximate_date
    return self.eventdates.first.calldate unless self.eventdates.first.nil?
  end

  def earliest_date
    return self.eventdates.collect{|ed| ed.calldate}.min unless self.eventdates.first.nil?
  end

  def to_s 
    return "#{self.title} on #{self.approximate_date.strftime('%D')}" unless self.approximate_date.nil?
    return "#{self.title}"
  end

  def members
    @members or @members = event_roles.inject(Array.new) do |uniq_roles, er| 
      ( uniq_roles << er.member unless er.member.nil? or uniq_roles.any? { |ur| ur.id == er.member_id } ) or uniq_roles 
    end
    
  end
end

# == Schema Information
#
# Table name: events
#
#  id              :integer(11)     not null, primary key
#  title           :string(255)     default(""), not null
#  organization_id :integer(11)     default(0), not null
#  status          :string(255)     default("Initial Request"), not null
#  contactemail    :string(255)
#  blackout        :boolean(1)      default(FALSE), not null
#  updated_on      :datetime
#  publish         :boolean(1)      default(FALSE)
#  rental          :boolean(1)      not null
#  year_id         :integer(11)     not null
#  contact_name    :string(255)     default(""), not null
#  contact_phone   :string(255)     default(""), not null
#  price_quote     :integer(11)
#  comments        :text
#

