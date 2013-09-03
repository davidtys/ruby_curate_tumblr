module CurateTumblr
  module Render	
    class RenderReblog < RenderLinks

	  def initialize( tumblr_name, directory='/home/tumblr' )
	    super( tumblr_name, directory )
	    @filename_links = @curator.get_filename_links
	  end

      def render_link( link, new_links, links_errors )
        @curator.reblog_and_extract( link ) 
      end  

      def get_max
        @curator.max_reblogged
      end      

      def get_count
        @curator.count_rebloged
      end

      private

        def after_render
          super
          @curator.add_tofollow_tofile
          @curator.add_externallinks_tofile
          add_info_render( "reblogged #{@curator.count_rebloged} links in #{to_s}" )
        end
    end
  end    
end
