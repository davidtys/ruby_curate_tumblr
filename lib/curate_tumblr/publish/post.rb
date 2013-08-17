module CurateTumblr
  module Publish  
    module Post

      def init_post!( hash_config={} )
      end
 
      def post_photos( photos_paths, caption='' )
        caption = caption + @infos_caption
        photos_paths = [photos_paths] if photos_paths.is_a? String
        CurateTumblr.check_paths_ar_photos( photos_paths )
        client_post_photos( photos_paths, body )
      end
    
      def post_text( title, body )
        body = body + @infos_caption
        client_post_text( title, body )        
      end
   end        
  end
end