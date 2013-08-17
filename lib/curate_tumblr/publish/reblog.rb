module CurateTumblr
  module Publish
    module Reblog

      def init_reblog!( hash_config={} )
      end

	    def reblog_and_extract( url )
	      return false if @is_stop
	      return false if !CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( url )
	      if !CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( url ) 
	        return reblog_and_add_tofollow_reblog_url( url ) if CurateTumblr::Tumblr::ExtractLinks.tumblr_reblog_url?( url )
	        return add_tofollow_url( url ) 
	      end
	      reblog_and_toadd_tofollow_from_post_url( url )
	    end    

      private 
    
      # --- reblog ---
 
      def reblog_and_add_tofollow_reblog_url( reblog_url )
        post_id = CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_reblog_url( reblog_url )
        if !CurateTumblr.post_id_valid?( post_id )
          return return_error( __method__, "post_id not valid", { post_id: post_id, reblog_url: reblog_url } ) 
        end
        reblog_key = CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url( reblog_url )
        if !CurateTumblr.reblog_key_valid?( reblog_key )
          return return_error( __method__, "reblog_key not valid", { reblog_key: reblog_key, post_id: post_id, reblog_url: reblog_url } ) 
        end
        new_post_id = reblog_post_key( post_id, reblog_key )  
        add_tofollow_source_from_post_id( @tumblr_name, new_post_id )
        new_post_id
      end
 
      def reblog_and_toadd_tofollow_from_post_url( post_url )
        hash_url = CurateTumblr.get_hash_url_from_post_url( post_url )
        if !CurateTumblr.hash_url_valid?( hash_url )
          return return_error( __method__, "hash_url not valid", { hash_url: hash_url, post_url: post_url } ) 
        end

        reblog_and_add_tofollow_post_id( hash_url[:tumblr_url], hash_url[:post_id] )
      end
     
      def reblog_and_add_tofollow_post_id( tumblr_url, post_id )
        hash_post = get_hash_post( tumblr_url, post_id ) 
        return false if !hash_post
        id = reblog_from_hash_post( hash_post )
        add_tofollow_from_post( tumblr_url, hash_post ) 
        extract_links_caption_from_post( hash_post ) 
        id
      end
  
      def reblog_from_hash_post( hash_post )
        post_id = hash_post["id"]
        reblog_key = CurateTumblr.get_reblog_key_from_hash_post( hash_post )
        return false if !reblog_key   
        reblog_post_key( post_id, reblog_key )
      end
  
      def reblog_post_key( post_id, reblog_key )
        # @log_tumblr.debug "#{__method__} count=#{self.count} for #{self.max_posts}" if @is_debug
        return false if !reblog_post?( post_id, reblog_key )
        client_reblog( post_id, reblog_key )
      end

      def reblog_post?( post_id, reblog_key )
        if !can_run?
          @log_tumblr.debug "can't reblog #{post_id} because can't run" if @is_debug 
          return false 
        end
        
        if !CurateTumblr.post_id_valid?( post_id )
          @log_tumblr.warn "#{__method__} post_id #{post_id} is not valid"
          return false 
        end
        
        if !CurateTumblr.reblog_key_valid?( reblog_key )
          @log_tumblr.warn "#{__method__} reblog_key #{reblog_key} is not valid for post_id #{post_id}"
          return false 
        end
        true        
      end
    end
  end
end
