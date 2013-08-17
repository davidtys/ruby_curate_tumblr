module CurateTumblr
  module Render	
    class RenderFollow < RenderLinks
      def initialize( tumblr_name, directory='/home/tumblr' )
	    	super( tumblr_name, directory )
	    	@filename_links = @curator.get_filename_tofollow
	    end

      def render_link( link, new_links, links_errors )
        @curator.client_follow( link ) 
      end  

      def get_max
        @curator.max_followed
      end      

      def get_count
        @curator.count_followed
      end

      private

        def after_render
          super
          add_info_render( "followed #{@curator.count_followed} links in #{to_s}" )
        end      
    end
  end    
end