module CurateTumblr
  module Tumblr
    module Infos

      HASH_CONFIG_INFOS = "infos"
      HASH_CONFIG_INFOS_TAGS = "tags"
      HASH_CONFIG_INFOS_TITLE = "title"

      attr_accessor :infos_caption, :infos_tags, :infos_title
      attr_reader :state

      class << self
        def get_infos_config_hash
          {
            HASH_CONFIG_INFOS => { }
          }
        end

        def get_string_yaml_from_infos_config( hash_config )
          hash_infos_config = hash_config[HASH_CONFIG_INFOS]
          %Q{
            #{Infos::HASH_CONFIG_INFOS}:
          }
        end        

        def check_infos_config_hash( hash_config )
          if hash_config.has_key?( HASH_CONFIG_INFOS )
            hash_infos_config = hash_config[HASH_CONFIG_INFOS]
            # nothing to check now
          end
        end
      end

      # --- config ---

      def init_infos!( hash_config={} )
        @infos_caption = ''
        @infos_tags = ''
        @infos_title = ''
        @state = STATE_QUEUE
        config_infos( hash_config ) if !hash_config.empty?
      end

      def config_infos( hash_config )
        hash_infos = hash_config[HASH_CONFIG_INFOS]
        return if hash_infos.nil?
        @infos_tags = hash_infos[HASH_CONFIG_INFOS_TAGS] if hash_infos.has_key?( HASH_CONFIG_INFOS_TAGS )
        @infos_title = hash_infos[HASH_CONFIG_INFOS_TITLE] if hash_infos.has_key?( HASH_CONFIG_INFOS_TITLE )
        set_title_caption if !@infos_title.empty?
      end

      def check_infos_config
      end    

      # --- options ---

      def get_tumblr_domain
        @tumblr_name + ".tumblr.com"
      end
   
      def post_in_published
        @state = STATE_PUBLISHED
      end
       
      def post_in_draft
        @state = STATE_DRAFT
      end
       
      def post_in_queue
        @state = STATE_QUEUE
      end
       
      def post_in_private
        @state = STATE_PRIVATE
      end    

      def in_published?
        @state == STATE_PUBLISHED
      end   

      def set_title_caption( title="", link="", style_begin="<i>", style_end="</i>", before="<p>&nbsp;</p>", after="")
        title = @infos_title if title.empty?
        raise "no title" if title.empty?
        link = "http://www.#{@tumblr_name}.tumblr.com" if link.empty?
        @infos_caption = "#{before}<p><a href='#{link}' target='_blank'>"
        @infos_caption = @infos_caption + "#{style_begin}" if !style_begin.empty?
        @infos_caption = @infos_caption + "#{title}"
        @infos_caption = @infos_caption + "#{style_end}" if !style_end.empty?
        @infos_caption = @infos_caption + "</a></p>#{after}"
      end    
            
      def add_infos_ar_tags( ar_tags ) 
        add_infos_tags( ar_tags.join(", ") )
      end

      def add_infos_tags( tags ) 
        @infos_tags += ", " if !@infos_tags.empty?
        @infos_tags += tags
      end    
    end
  end
end