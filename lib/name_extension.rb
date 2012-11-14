class Net::SFTP::Protocol::V01::Name
  def is_directory?()
    return (directory?) ? 1 : 0
  end
end
