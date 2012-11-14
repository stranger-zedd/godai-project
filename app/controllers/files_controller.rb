class FilesController < AuthenticatedController
  def index
    set_up_list
  end

  def list
    set_up_list
  end

  def get
    name = File.basename params[:file]
    extension = File.extname(name)[1..-1] || ""
    type = Mime::Type.lookup_by_extension(extension.downcase) || ""
    response_params = {:filename => name, :type => type }

    if(type.to_s.split('/')[0] == 'image')
      response_params[:disposition] = 'inline'
    end

    file = FileManager.get_file(FileManager.path_to(params[:file], current_user))
    send_data(file.read(), response_params)
    file.close
  end

  def destroy
    FileManager.delete(params[:file], current_user)
    redirect_to request.referrer
  end

  def new_directory
    FileManager.mkdir(FileManager.path_to(File.join(params[:current_dir], params[:dir]), current_user))
    redirect_to request.referer
  end

  def delete_directory
    FileManager.delete_directory(params[:dir], current_user)
    redirect_to request.referrer
  end

  private
  def set_up_list
    @dir = params[:dir] || "/"
    @dir_up = @dir.sub(/[^\/]+\/\Z/, "") if @dir != "/"

    @files = FileManager.get_files_in(FileManager.path_to(@dir, current_user))
    sort_files(@files, @dir)
  end

  def sort_files (files, dir)
    files.sort_by! { |file| [is_directory(file, dir), file.name] }
  end

  def is_directory(file, dir)
    # Need to deal with symlinks specially, since Dir.each doesn't follow 
    # them for its stat
    if(file.symlink?)
      stat = FileManager.stat(FileManager.path_to(File.join(dir, file.name), current_user))
    else
      stat = file
    end

    return (stat.directory?) ? 0 : 1
  end
end
