class UserSession < Authlogic::Session::Base

  verify_password_method :sftp_login?

end
