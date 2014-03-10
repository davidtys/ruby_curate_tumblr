
module CurateTumblr

  def self.reblog( tumblr_name, directory, is_display_infos=true )
    Render::RenderLinks.render( Render::RenderReblog.new( tumblr_name, directory ), __method__, is_display_infos )
  end  

  def self.follow( tumblr_name, directory, is_display_infos=true )
    Render::RenderLinks.render( Render::RenderFollow.new( tumblr_name, directory ), __method__, is_display_infos )
  end       

  class Curator
    include Tumblr::Client
    include Tumblr::Infos
    include Tumblr::ExtractLinks
    include Publish::Follow
    include Publish::Reblog
    include Publish::Post

   	attr_accessor :tumblr_name, :is_stop, :is_debug, :log_tumblr, :directory

    class << self
      def create_config_yaml_file( file_yaml, hash_config )
        check_config_hash( hash_config )
        document = get_string_yaml_from_config( hash_config )
        File.open( file_yaml, "w+") { |file| file.puts( document ) }
      end

      def get_string_yaml_from_config( hash_config )
        Tumblr::Client::get_string_yaml_from_client_config( hash_config ) + "\n\n" +
        Tumblr::Infos::get_string_yaml_from_infos_config( hash_config ) 
      end
   
      def check_config_hash( hash_config )
        raise "config must be a Hash instead of #{hash_config.class}" if !hash_config.is_a?( Hash )
        Tumblr::Client::check_client_config_hash( hash_config )
        Tumblr::Infos::check_infos_config_hash( hash_config )
        hash_config
      end
    end      

    # --- config ---

   	def initialize( tumblr_name, directory='/home/tumblr' )
      @tumblr_name = tumblr_name
      @directory = directory 

      init_tumblr!
      check_config
      @is_debug = false
 		end

 		def init_tumblr!( hash_config={} )
      @is_stop = false   
      check_config_files 
      return false if !check_init_ok
      hash_config = get_config_from_yaml if hash_config.empty? && !is_stop
      return false if !check_init_ok
      set_log
      return false if !check_init_ok
			init_client!( hash_config )
      return false if !check_init_ok
      init_infos!( hash_config )
      return false if !check_init_ok
      init_extract_links!( hash_config )
      return false if !check_init_ok
      init_follow!( hash_config )
      return false if !check_init_ok
      init_reblog!( hash_config )
      return false if !check_init_ok
      init_post!( hash_config )
      return false if !check_init_ok
      true
 	  end

    def check_init_ok
      return return_error( __method__, "the application can't init. Please check the paths and the config file", {}, true ) if @is_stop
      true
    end

    def config_from_yaml
      hash_config = get_config_from_yaml
      return false if !check_init_ok
      raise "can't get config from file #{get_filename_config}" if !hash_config
      raise "config is empty from file #{get_filename_config}" if hash_config.empty?
      config_client( hash_config )
      config_infos( hash_config )
    end      

    def check_config_files
      return false if !check_config_dir( @directory, "You need it for your tumblrs subdirectories." )
      return false if !check_config_dir( get_path_tumblr, "You need it for your tumblr links and config." )
      return false if !check_config_dir( get_path_links, "You need it for set the links to follow and reblog." )
      return false if !check_config_dir( get_path_logs, "The application needs it for write logs." )
      return false if !check_config_file( get_filename_config, "You need it for set oauth tokens." )
      return false if !check_config_file( get_filename_links, "You need it for set the links to reblog." )
      return false if !check_config_key( Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH, "you need to write it in config file to write inside the oauth tokens to send requests to Tumblr", false )
      return false if !check_config_key( Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY, "you need to write it inside '#{Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH}' in config file to send requests to Tumblr" )
      return false if !check_config_key( Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET, "you need to write it inside '#{Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH}' in config file to send requests to Tumblr" )
      return false if !check_config_key( Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH_TOKEN, "you need to write it inside '#{Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH}' in config file to send requests to Tumblr" )
      return false if !check_config_key( Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET, "you need to write it inside '#{Tumblr::Client::HASH_CONFIG_CLIENT_OAUTH}' in config file to send requests to Tumblr" )
      true      
    end

    def check_config_dir( dir, about )
      if !Dir.exists?( dir )
        return error_config( "The directory #{dir} doesn't exist", about + "\nPlease create it or change the path." )
      end
      true
    end

    def check_config_file( file, about )
      if !File.exists?( file )
        return error_config( "The file #{file} doesn't exist", about + "\nPlease create it or change the path." )
      end
      true
    end    

    def check_config_key( key, about, is_check_empty=true )
      ar_key = []
      File.open( get_filename_config, "r" ) do |file_config|
        ar_key = file_config.grep( /#{key}:/ )
        if ar_key.count <= 0 
          return error_config( "There is no '#{key}' in #{get_filename_config}", about )
        end
      end
      if is_check_empty
        if ar_key[0].split(":").count <= 1
          return error_config( "'#{key}' is empty in #{get_filename_config}", about )
        end
        if ar_key[0].split(":")[1].gsub( /\s+/, "" ).gsub( /"/, "" ).empty?
          return error_config( "'#{key}' is empty in #{get_filename_config}", about )
        end
      end
      true
    end

    def error_config( error, about )
      puts "\nOups! #{error} \n#{about}"
      @is_stop = true
      false
    end

    def get_config_from_yaml
      if @is_stop
        @log_tumblr.error( "don't get config because must stop" )
        return false
      end
      file_yaml = get_filename_config
      raise "config file YAML #{file_yaml} doesn't exist" if !File.exist?( file_yaml )
      begin
        documents = YAML::load_documents( File.open( file_yaml ) )
      rescue => exception
        raise "can't load config from YAML #{file_yaml} : #{exception} "
      end
      raise "config from YAML #{file_yaml} is empty" if documents.empty?
      Curator.check_config_hash( documents.first )
    end  

    def check_config
      raise "directory is empty" if @directory.empty?
      raise "tumblr_name is empty" if @tumblr_name.empty?
      check_client_config
      check_infos_config
    end

    # --- options ---

    def stop_it!( reason='' )
      @is_stop = true
      @log_tumblr.warn( "stop it because " + reason ) if !reason.empty?
    end       

    def debug
      @is_debug = true
    end      

    def can_run?
      return false if self.is_stop
      true
    end

    # --- files ---

    def add_tofollow_tofile( is_delete_tofollow=true )
      raise "no urls to follow" if !@all_tofollow_urls
      return false if @all_tofollow_urls.empty?
      @all_tofollow_urls = CurateTumblr.get_format_tumblr_urls( @all_tofollow_urls )
      return false if !CurateTumblr.add_set_tofile_without_repeat( get_filename_tofollow, @all_tofollow_urls  ) 
      @all_tofollow_urls = Set.new if is_delete_tofollow
      true
    end       

    def add_externallinks_tofile( is_delete_externallinks=true )
      @all_external_links = CurateTumblr.get_format_urls( @all_external_links)
      return false if !CurateTumblr.add_set_tofile_without_repeat( get_filename_external_links, @all_external_links ) 
      @all_external_links = Set.new if is_delete_externallinks
      true
    end    

    # --- paths ---

    def get_path_tumblr
      @directory + "/" + @tumblr_name
    end

    def get_path_logs
      get_path_tumblr + "/logs" 
    end

    def get_path_links
      get_path_tumblr + "/links"
    end

    def get_path_config
      get_path_tumblr 
    end

    def get_filename_config
      get_path_config + "/" + @tumblr_name + "_config.yaml"
    end

    def get_filename_values
      get_path_config + "/" + @tumblr_name + "_values.yaml"
    end

    def get_filename_log
      get_path_logs + "/" + @tumblr_name + "_log"
    end

    def get_filename_errors
      get_path_logs + "/" + @tumblr_name + "_errors"
    end      

    def get_filename_links
      get_path_links + "/" + @tumblr_name + "_links"
    end

    def get_filename_tofollow
      get_path_links + "/" + @tumblr_name + "_tofollow"
    end

    def get_filename_external_links
      get_path_links + "/" + @tumblr_name + "_external_links"
    end

    def set_log
      @log_tumblr = Logger.new( get_filename_log )
    end

    def new_log( info )
      default_log
      @log_tumblr << "\n"
      @log_tumblr.info( info )
    end

    private

    def stop_and_alert(message, is_display=true, is_log=true )
      @log_tumblr.error( message ) if is_log && @log_tumblr
      puts "\n*** Stop it ! #{message} ***" if is_display
      stop_it!
    end  

    def error( method, message, hash_infos={}, is_display=false )
      error = "#{@domain} : #{message} in #{method} "
      if !hash_infos.empty?
      error = error + " with" 
      hash_infos.each { |key, value| error = error + " [#{key} : #{value}]" }
      end
      @log_tumblr.error( error ) if !@log_tumblr.nil?
      puts "\nError : #{message}" if is_display || @log_tumblr.nil?
     end
       
    def return_error( method, message, hash_infos={}, is_display=false )
      error( method, message, hash_infos, is_display )
      false
    end    
  end
end