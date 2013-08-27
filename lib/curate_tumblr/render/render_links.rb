module CurateTumblr
  module Render
    class RenderLinks
      include Enumerable # links      

      attr_accessor :links_to_render, :filename_links, :filename_errors, :is_stop
      attr_reader :info_render
            
      class << self
        def render( object_render, name, is_display_infos=true )
          return false if object_render.is_stop
          puts "\n#{name} begin at #{Time.now.strftime("%H:%m")} (max #{object_render.get_max})" if is_display_infos
          object_render.render_links_from_file
          puts "\n#{name} end at #{Time.now.strftime("%H:%m")}" if is_display_infos
          puts "> #{object_render.info_render}" if is_display_infos
          object_render
        end
      end

      def initialize( tumblr_name, directory='/home/tumblr' )
        @curator = Curator.new( tumblr_name, directory )
        reboot!( false )
        @filename_errors = @curator.get_filename_errors
      end

      def reboot!( is_init_curator=true )
        @curator.init_tumblr! if is_init_curator
        @links_to_render = Set.new 
        @info_render = ""
        @is_stop = @curator.is_stop
      end

      def add_links_to_render( links )
        links = links.to_a if !links.is_a?( Array ) && !links.is_a?( Set )
        links = Set.new( links ) if !links.is_a? Set
        links = Set.new( links.to_a.shuffle )
        @links_to_render += links
      end  

      def render_links_from_file
        before_render
        new_links = @links_to_render.dup
        links_errors = Set.new

        @links_to_render.each do |link|
          break if check_if_stop
          result = render_link( link.chomp, new_links, links_errors )          
          links_errors << link.chomp if !result
          new_links.delete( link )
          after_render_link( link, result )
        end     

        @links_to_render = new_links        
        after_render
        add_links_errors_file( links_errors )
        get_count
      end  

      def get_all_published_id
        @curator.all_published_id
      end

      def get_count_all_requests_and_posts
        @curator.count_all_requests_and_posts
      end

      def get_links_torender_from_file
        CurateTumblr.get_ar_from_file( @filename_links )
      end

      def to_s
        "#{@curator.state} #{@curator.tumblr_name} (#{@curator.count_all_requests_and_posts} total requests and posts)"
      end

      # --- methods to define in child ---

      def render_link( link, new_links, links_errors )
        raise "no render method"
      end  

      def get_max
        raise "no max method"
      end

      def get_count
        raise "no count method"
      end

      private

        def check_if_stop
          @is_stop = true if get_count >= get_max
          @is_stop = @curator.is_stop if !@is_stop
          @is_stop
        end

        def after_render_link( link, result )
        end

        def before_render
          raise "no filename for links" if !@filename_links
          CurateTumblr.backup_file( @filename_links )
          add_links_to_render( get_links_torender_from_file )
        end

        def after_render
          replace_links_torender_in_file( @links_to_render )
        end

        def replace_links_torender_in_file( new_links )
          new_links = Set.new( new_links.to_a.shuffle )
          File.open( @filename_links , "w+" ) { |file| file.puts( new_links.to_a ) }
        end

        def add_links_errors_file( links_errors )
          File.open( @filename_errors, "a" ) { |file| file << "\n" + links_errors.to_a.join("\n")  }
        end         

        def empty_file_links_reblog
          File.open( @filename_links, "w+" ) { }
        end   

        def add_links_errors_file( links_errors )
          File.open( @filename_errors, "a" ) { |file| file << "\n" + links_errors.to_a.join("\n")  }
        end         

        def add_info_render( info )
          @info_render = info
          @curator.log_tumblr.info(info)
        end 
    end
  end  
end