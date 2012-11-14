class User < ActiveRecord::Base
  attr_accessible :login, :persistence_token

  acts_as_authentic do |c|
    c.validate_password_field = false
  end

  def sftp_login?(password) 
    begin
      FileManager.connect(login, password)
    rescue Exception => e
      puts e.message
      return false
    end
    return true
  end
end
