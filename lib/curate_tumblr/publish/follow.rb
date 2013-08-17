module CurateTumblr
  module Publish
    module Follow

      attr_accessor :all_tofollow_urls

      def init_follow!( hash_config={} )
        @all_tofollow_urls = Set.new
      end

      def follow_url( url )
        tumblr_url = CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( url )
        client_follow( tumblr_url )
      end

      def add_tofollow_url( url )
        raise "no tumblr url" if !url
        url = CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( url ) if !CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( url )
        return false if !url || !CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( url )
        tumblr_url = url.dup
        CurateTumblr.format_tumblr_url!( tumblr_url )
        @all_tofollow_urls << tumblr_url
        @all_tofollow_urls.count
      end      

    private

      def add_tofollow_tumblr_links_from_caption( caption, source=false )
        tumblr_links = CurateTumblr::Tumblr::ExtractLinks.get_tumblr_urls_from_text( caption )
        tumblr_links.each { |link| add_tofollow_url( link ) if !source || source != link  }
        tumblr_links
      end

      def add_tofollow_source_from_hash_post( hash_post )
        source = CurateTumblr.get_source_from_hash_post( hash_post )
        return false if !source
        add_tofollow_url( source )
      end          
      
      def add_tofollow_from_post( tumblr_url, hash_post )
        raise "no tumblr url" if !tumblr_url
        if !add_tofollow_url( tumblr_url )
          return_error( __method__, "can't follow tumblr url", { tumblr_url: tumblr_url, hash_post: CurateTumblr.get_summary_hash_post( hash_post ) } )
        end         
        add_tofollow_source_from_hash_post( hash_post )
        add_tofollow_link_url_from_hash_post( hash_post )
        true
      end   
      
      def add_tofollow_source_from_post_id( tumblr_url, post_id )
        raise "no tumblr url" if !tumblr_url
        add_tofollow_source_from_hash_post( get_hash_post( tumblr_url, post_id ) )        
      end

      def add_tofollow_link_url_from_hash_post( hash_post )
        link_url = CurateTumblr.get_link_url_from_hash_post( hash_post )
        return false if !link_url
        add_tofollow_url( link_url )
      end 
    end
	end
end