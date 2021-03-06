module FilesHelper
  def generate_file_row(file, dir)
    if(file.symlink?)
      stat = FileManager.stat(FileManager.path_to(File.join(dir, file.name), UserSession.find.user))
    else
      stat = file;
    end

    haml_tag 'td', :class => 'file-name' do
      haml_concat_icon(file, stat)
      if(stat.directory?)
        haml_concat(link_to(file.name, files_path(:dir => "#{File.join(dir, file.name)}/")))
      else
        haml_concat(link_to(file.name, get_file_path(:file => "#{File.join(dir, file.name)}")))
      end
    end
    haml_tag 'td' do
      # Needs to check if the actual FILE is a directory, not if it's a link 
      # that points to a directory. Otherwise we'd delete the whole folder 
      # contents, when all we want is to get rid of the symlink
      if(file.directory?)
        haml_concat(link_to raw('<i class="icon-trash"></i>'), 
                    delete_directory_path(:dir => "#{File.join(dir, file.name)}"),
                    :confirm => "Are you sure you want to delete the directory \"#{file.name}\" and all contents?")
      else
        haml_concat(link_to raw('<i class="icon-trash"></i>'), 
                    delete_file_path(:file => "#{File.join(dir, file.name)}"))
      end
    end
  end

  def haml_concat_icon(file, stat)
    if(stat.directory?)
        haml_concat(raw('<i class="icon-folder-open"></i>'))      
    else
      extension = File.extname(file.name)[1..-1] || ""
      type = Mime::Type.lookup_by_extension(extension.downcase) || ""
      case type.to_s.split('/')[0]
        when 'image'
          haml_concat(raw('<i class="icon-picture"></i>'))
        when 'sound'
          haml_concat(raw('<i class="icon-music"></i>'))
        else 
          haml_concat(raw('<i class="icon-file"></i>'))
      end
    end
  end
end
