module CurateTumblr
  module Tumblr
	  module ExtractLinks
		  attr_reader :all_external_links, :links_tofollow

      REGEX_TUMBLR_URL = ".*.tumblr.com"
      REGEX_TUMBLR_POST_SLUG_URL = "post/.*/"
      REGEX_TUMBLR_POST_URL = "post/.*"
      REGEX_TUMBLR_REBLOG_URL = "reblog/.*/"
      REGEX_TUMBLR_URL_REBLOG_URL_SPEC = "http%3A%2F%2F.*.tumblr.com"
      REGEX_TUMBLR_URL_REBLOG_URL = "http://.*.tumblr.com"
      REGEX_TUMBLR_GLOBALKEY_REBLOG_URL = "reblog/.*"
      REGEX_TUMBLR_KEY_REDIRECT_REBLOG_URL = "/.*\\?"
      REGEX_TUMBLR_KEY_REBLOG_URL = "/.*"
      # REGEX_EXTRACT_TUMBLR = "href=.*.tumblr.com"
      REGEXS_EXTRACTS_TUMBLR = [ "\".*.tumblr.com\"", "\".*.tumblr.com/\"", "\".*.tumblr.com/post", ".*.tumblr.com/post" ]
      #REGEX_EXTERNALS_FLICKR = [ "\".*flickr.com/photos/.*\"" ]
      REGEX_EXTERNALS_LINKS = [ "href=\".*.com.*\""]

      class << self
        def get_tumblr_url( url )
          return false if !tumblr_url?( url )      
          tumblr_url = url.scan(/#{REGEX_TUMBLR_URL}/).first
          CurateTumblr.format_tumblr_url!( tumblr_url )
          tumblr_url
        end

        def get_tumblr_from_reblog_url( reblog_url )
          return false if !tumblr_reblog_url?( reblog_url )  
          if /#{REGEX_TUMBLR_URL_REBLOG_URL_SPEC}/ =~ reblog_url
            tumblr_url = reblog_url.scan( /#{REGEX_TUMBLR_URL_REBLOG_URL_SPEC}/ ).first 
          elsif /#{REGEX_TUMBLR_URL_REBLOG_URL}/ =~ reblog_url
            tumblr_url = reblog_url.scan( /#{REGEX_TUMBLR_URL_REBLOG_URL}/ ).first
          else
            tumblr_url = ""
          end 
          CurateTumblr.format_tumblr_url!( tumblr_url )
          tumblr_url
        end

        def get_post_id_from_post_url( url )
          return false if !tumblr_post_url?( url )
          return CurateTumblr.format_post_id( url.scan( /#{REGEX_TUMBLR_POST_SLUG_URL}/ ).first.gsub('post/', '') ) if /#{REGEX_TUMBLR_POST_SLUG_URL}/ =~ url
          return CurateTumblr.format_post_id( url.scan( /#{REGEX_TUMBLR_POST_URL}/ ).first.gsub('post/', '') ) if /#{REGEX_TUMBLR_POST_URL}/ =~ url
          false
        end
      
        def get_post_id_from_reblog_url( url )
          return false if !tumblr_reblog_url?( url )
          CurateTumblr.format_post_id( url.scan(/#{REGEX_TUMBLR_REBLOG_URL}/).first.gsub('reblog/', '') )
        end    
      
        def get_reblog_key_from_reblog_url( url )
          return false if !tumblr_reblog_url?( url )
          global_key = url.scan(/#{REGEX_TUMBLR_GLOBALKEY_REBLOG_URL}/).first.gsub('reblog/', '')
          return false if global_key.empty?
          return CurateTumblr.format_post_reblog_key( global_key.scan( /#{REGEX_TUMBLR_KEY_REDIRECT_REBLOG_URL}/ ).first ) if /#{REGEX_TUMBLR_KEY_REDIRECT_REBLOG_URL}/ =~ global_key
          return CurateTumblr.format_post_reblog_key( global_key.scan( /#{REGEX_TUMBLR_KEY_REBLOG_URL}/ ).first ) if /#{REGEX_TUMBLR_KEY_REBLOG_URL}/ =~ global_key
          false
        end      

        def simple_tumblr_url?( url )
          return true if /#{REGEX_TUMBLR_URL}/ =~ url
          false 
        end

        def tumblr_url?( url )
          return true if simple_tumblr_url?( url ) &&
            !url.index("<a ") && !url.index("</a>") && !url.index("</a>")
          false 
        end

        def tumblr_post_url?( url )
          return false if !tumblr_url?( url )
          return true if /#{REGEX_TUMBLR_POST_SLUG_URL}/ =~ url 
          return true if /#{REGEX_TUMBLR_POST_URL}/ =~ url 
          false
        end

      def tumblr_reblog_url?( url )
        return false if !tumblr_url?( url )
        return true if /#{REGEX_TUMBLR_REBLOG_URL}/ =~ url 
        false
      end
      
      def valid_tumblr_url?( tumblr_url )
        REGEXS_EXTRACTS_TUMBLR.each do |regex|
          if /#{regex}/ =~ tumblr_url 
          else
            return false
          end
          true
        end
      end

      def get_tumblr_links_from_regexs_caption( ar_regexs, caption )
        ar_links = []
        ar_regexs.each { |regex| ar_links += get_tumblr_link_from_regex_caption( regex, caption ) }      
        ar_links        
      end

      def get_tumblr_link_from_regex_caption( regex, caption )
        if /#{regex}/ =~ caption
            return CurateTumblr.get_format_ar_tumblrs_urls( caption.scan( /#{regex}/ ) )
        end
        []
      end

      def get_links_from_regexs_caption( ar_regexs, caption )
        ar_links = []
        ar_regexs.each { |regex| ar_links += get_link_from_regex_caption( regex, caption ) }      
        ar_links        
      end

      def get_link_from_regex_caption( regex, caption )
        if /#{regex}/ =~ caption
            return CurateTumblr.get_format_ar_urls( caption.scan( /#{regex}/ ) )
        end
        []
      end    

      def get_urls_only_tumblr( ar_urls )
        ar_new_urls = []
        ar_urls.each do |url|
          ar_new_urls << url if tumblr_url?( url )
        end
        ar_new_urls
      end

     def get_urls_not_tumblr( ar_urls )
        ar_new_urls = []
        ar_urls.each do |url|
          ar_new_urls << url if !simple_tumblr_url?( url ) 
        end
        ar_new_urls
      end    

      def get_tumblr_urls_from_text( text )
        raise "text #{text.class} is not a String" if !text.is_a? String
        ar_urls = get_tumblr_links_from_regexs_caption( REGEXS_EXTRACTS_TUMBLR, text )
        ar_urls = get_urls_only_tumblr( ar_urls )
        ar_urls = CurateTumblr.get_format_ar_tumblr_urls( ar_urls )
        Set.new( ar_urls ).to_a
      end

      def get_external_urls_from_text( text )
        raise "text #{text.class} is not a String" if !text.is_a? String
        text.force_encoding 'utf-8'
        ar_urls = get_links_from_regexs_caption( REGEX_EXTERNALS_LINKS, text )
        ar_urls = get_urls_not_tumblr( ar_urls )
        ar_urls = CurateTumblr.get_format_ar_urls( ar_urls )
        Set.new( ar_urls ).to_a
      end   
    end

    # --- end of class methods ---

    def init_extract_links!( hash_config={} )
      @all_external_links = Set.new
    end

    def add_external_links_from_caption( caption )
      links = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( caption )
      links = Set.new( links ) if links.is_a? Array
      @all_external_links += links
      @all_external_links.count
    end

    def add_external_link( link )
      CurateTumblr.format_url!( link )
      @all_external_links << link
      @all_external_links.count
    end

    def extract_links_caption_from_post( hash_post )
      return false if !hash_post.has_key?( "caption" )
      add_tofollow_tumblr_links_from_caption( hash_post["caption"], CurateTumblr.get_source_from_hash_post( hash_post ) )
      add_external_links_from_caption( hash_post["caption"] )
      true        
    end

    # --- utils ---
  
    def get_reblog_key_from_post( tumblr_url, post_id )
      tumblr_url = @tumblr_name if tumblr_url.empty?
      CurateTumblr.get_reblog_key_from_hash_post( get_hash_post( tumblr_url, post_id ) )    
    end  
  end
 end
end