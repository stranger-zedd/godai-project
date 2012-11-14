class FileManager
  def self.connect(username, password)
    # Yes. It has to be global. This is because the sftp session is not 
    # serialisable and we still have to store it somewhere. Since rails stores
    # global variables one-per-process, it's actually not THAT bad anyway.
    $sftp_session = Net::SFTP.start('localhost', username, :password => password)
  end

  def self.connected?()
    if($sftp_session != nil)
      return $sftp_session.open?
    end

    return false
  end

  def self.user_home(user)
    "/home/#{user.login}/"
  end

  def self.stat(path)
    $sftp_session.stat!(path)
  end

  def self.path_to(file, user)
    File.join(user_home(user), file || "")
  end

  def self.get_file(path)
    $sftp_session.file.open(path)
  end

  def self.get_files_in(directory, show_hidden = false)
    $sftp_session.dir.entries(directory).select do |file|
      show_hidden || !file.name.starts_with?('.')
    end
  end

  def self.delete(file, user)
    $sftp_session.remove(path_to(file, user))
  end

  def self.mkdir(path)
    $sftp_session.mkdir(path)
  end

  def self.delete_directory(file, user)
    path = path_to(file, user)
    puts 'here ' + path

    for f in get_files_in(path)
      if(f.directory?)
        delete_directory(File.join(file, f.name), user)
      else
        $sftp_session.remove(File.join(path, f.name))
      end
    end

    $sftp_session.rmdir(path)
  end

  def self.close()
    begin
      $sftp.close_channel()
    rescue
      return false
    end
  end



end
