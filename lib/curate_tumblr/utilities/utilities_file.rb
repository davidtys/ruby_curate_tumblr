module CurateTumblr
  def self.get_filepath_links_by_tumblr( tumblrname, path=PATH_LINKS )
    path + tumblrname + "/" + tumblrname + "_links"
  end

  def self.get_filepath_errors_by_tumblr( tumblrname, path=PATH_LINKS )
    path + tumblrname + "/" + tumblrname + "_errors"
  end

  def self.get_filepath_tofollow_by_tumblr( tumblrname, path=PATH_LINKS )
    path + tumblrname + "/" + tumblrname + "_tofollow"
  end

  def self.get_filepath_externallinks_by_tumblr( tumblrname, path=PATH_LINKS )
    path + tumblrname + "/" + tumblrname + "_externallinks"
  end
        
  def self.get_ar_from_file( filename )
    raise "filename is empty" if filename.nil? || filename.empty?
    ::File.open( filename, "r" ).readlines
  end       

  def self.checkFile( filename )
    raise "Filename is empty" if filename.empty?
    raise "File #{filename} doesn't exist" if !::File.exists?( filename )
    raise "#{filename} is not a true file" if !::File.file?( filename )
    raise "File #{filename} is not readable" if !::File.readable?( filename )
    true        
  end  
    
  def self.backup_file( filename, backupname="" )
    return false if !::File.exists?( filename )
    backupname = filename + ".save" if backupname.empty?
    ::File.open(backupname , "w+" ) { |file| file.puts get_ar_from_file( filename ) }
    true
  end

  def self.add_set_tofile_without_repeat( filename, set_tofile )
    set_toadd = set_tofile.dup
    ::File.open( filename, "w" ) if !::File.exists?( filename )
    ar_file = get_ar_from_file( filename )
    ar_file.each { |line| format_tumblr_url!( line ) }
    set_toadd.merge( ar_file )
    ::File.open( filename, "w" ) { |file| file.puts( set_toadd.to_a )  }
    true
  end

  def create_config_file( filename, hash_config )
  end
end
