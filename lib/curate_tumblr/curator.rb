
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
       hash_config = get_config_from_yaml if hash_config.empty?
       set_log
			 init_client!( hash_config )
       init_infos!( hash_config )
       init_extract_links!( hash_config )
       init_follow!( hash_config )
       init_reblog!( hash_config )
       init_post!( hash_config )
       @is_stop = false    
 		end

    def config_from_yaml
      hash_config = get_config_from_yaml
      config_client( hash_config )
      config_infos( hash_config )
    end      

    def get_config_from_yaml
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
      @log_tumblr.error( message ) if is_log
      puts "\n*** Stop it ! #{message} ***" if is_display
      stop_it!
    end  

    def error( method, message, hash_infos={} )
      error = "#{@domain} : #{message} in #{method} "
      if !hash_infos.empty?
      error = error + " with" 
      hash_infos.each { |key, value| error = error + " [#{key} : #{value}]" }
      end
      @log_tumblr.error( error )
     end
       
    def return_error( method, message, hash_infos={} )
      error( method, message, hash_infos )
      false
    end    
  end
end