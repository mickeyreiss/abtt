# == Schema Information
# Schema version: 20100115155237
#
# Table name: members
#
#  id            :integer         not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  nick_name     :string(255)
#  phone         :string(255)
#  email         :string(255)
#  username      :string(255)
#  password_hash :string(255)
#  callsign      :string(255)
#  shirt_size    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Member < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :username, :password_hash
  validates_email_format_of :email
  validates_uniqueness_of :username

  attr_accessor :password, :password_confirmation
  validates_confirmation_of :password

  #Authenticate a member based on username and password, returns Member if good login or else returns nil
  def self.authenticate(name, password)
    user = self.find_by_username(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.password_hash != expected_password
        user = nil 
      end 
    end 
    user
  end 

  #Retunrs true or false depending on whether member is currently active?
  def active?
    #FIXME: should be based on member role and active status
    true
  end

  #Returns true or false depending on whether member is allowed to log in
  def can_login?
    active?
  end

  #Returns full name of member
  def full_name 
    first_name + ' ' + last_name
  end

  #TODO: implement permissions hierarchy
  def has_permission? permission
    true
  end

  def password
    @password
  end 

  def salt
    self.password_hash[40,50]
  end 

  def password=(pwd)
    @password = pwd 
    return if pwd.blank?
    create_new_salt
    self.password_hash = Member.encrypted_password(self.password, create_new_salt)
  end 

  def reset_password
      self.password= Member.random_password
      self.password_confirmation = self.password
  end

  def self.random_password
    symbols = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w{! @ # $ % ^ & *}
    password = ""
    10.times do 
      password += symbols[rand(symbols.length)]
    end
    password
  end

 protected
    def self.encrypted_password(password, salt)
      salted_password = password + salt
      require 'digest/sha1'
      Digest::SHA1.hexdigest(salted_password) + salt
    end

    def create_new_salt
      require 'digest/sha1'
      Digest::SHA1.hexdigest(self.object_id.to_s + rand.to_s)[0,10]
    end

    def create_new_api_key
      require 'digest/sha1'
      Digest::SHA1.hexdigest(self.object_id.to_s + rand.to_s)[0,32]
    end
end
