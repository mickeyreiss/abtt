class Session 
  include Validatable
  attr_accessor :username, :password

  validates_presence_of :username, :password

  def initialize(hash = nil)
    if hash
      @username = hash[:username] if hash[:username]
      @password = hash[:password] if hash[:password]
    end
  end
end

