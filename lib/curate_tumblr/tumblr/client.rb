module CurateTumblr
  module Tumblr
	 module Client
	  HASH_CONFIG_CLIENT = "client"
	  HASH_CONFIG_IS_RUNNING = "is_running"
	  HASH_CONFIG_SLEEP_BEFORE_CLIENT = "sleep_before_client"
	  HASH_CONFIG_SLEEP_BEFORE_CLIENT_MIN = "sleep_before_client_min"
	  HASH_CONFIG_SLEEP_BEFORE_CLIENT_MAX = "sleep_before_client_max"
	  HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MIN = "sleep_before_follow_min"
	  HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MAX = "sleep_before_follow_max"
	  HASH_CONFIG_MAX_REQUESTS_AND_POSTS = "max_requests_and_posts"
	  HASH_CONFIG_MAX_POSTED = "max_posted"
	  HASH_CONFIG_MAX_REBLOGGED = "max_reblogged"
	  HASH_CONFIG_MAX_FOLLOWED = "max_followed"
	  HASH_CONFIG_CLIENT_OAUTH = "oauth"
	  HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY = "consumer_key"
	  HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET = "consumer_secret"	
	  HASH_CONFIG_CLIENT_OAUTH_TOKEN = "token"
	  HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET = "token_secret"	

		attr_accessor :client, :sleep_before_client, :sleep_before_client_min, :sleep_before_client_max, :sleep_before_follow_min, :sleep_before_follow_max,  
			:max_requests_and_posts, :max_posted, :max_reblogged, :max_followed
	 	attr_reader :all_published_id, :count_all_requests_and_posts, :count_continuous_bad_requests, :count_posted, :count_rebloged, :count_followed

	 	class << self
      def get_client_config_hash( oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret )
        {
          HASH_CONFIG_CLIENT => {
	          HASH_CONFIG_CLIENT_OAUTH => {
	            HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY => oauth_consumer_key,
	            HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET => oauth_consumer_secret, 
	            HASH_CONFIG_CLIENT_OAUTH_TOKEN => oauth_token,
	            HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET => oauth_token_secret, 
	          }
	        }
	      }
      end

      def get_string_yaml_from_client_config( hash_config )
        hash_client_config = hash_config[HASH_CONFIG_CLIENT]
        %Q{
          #{HASH_CONFIG_CLIENT}:
            #{HASH_CONFIG_CLIENT_OAUTH}:
              #{HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY}:        "#{hash_client_config[HASH_CONFIG_CLIENT_OAUTH][HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY]}"
              #{HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET}:     "#{hash_client_config[HASH_CONFIG_CLIENT_OAUTH][HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET]}"
              #{HASH_CONFIG_CLIENT_OAUTH_TOKEN}:               "#{hash_client_config[HASH_CONFIG_CLIENT_OAUTH][HASH_CONFIG_CLIENT_OAUTH_TOKEN]}"
              #{HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET}:        "#{hash_client_config[HASH_CONFIG_CLIENT_OAUTH][HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET]}"
        }
      end          

	    def check_client_config_hash( hash_config )
        hash_config.check_key( HASH_CONFIG_CLIENT )
        hash_client_config = hash_config[HASH_CONFIG_CLIENT]
        hash_client_config.check_key( HASH_CONFIG_CLIENT_OAUTH )
        hash_client_config[HASH_CONFIG_CLIENT_OAUTH].check_key( HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY )
        hash_client_config[HASH_CONFIG_CLIENT_OAUTH].check_key( HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET )
        hash_client_config[HASH_CONFIG_CLIENT_OAUTH].check_key( HASH_CONFIG_CLIENT_OAUTH_TOKEN )
        hash_client_config[HASH_CONFIG_CLIENT_OAUTH].check_key( HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET )
	    end
	 	end

	 	# --- config ---

	  def init_client!( hash_config={} )
	    @all_published_id = Set.new
			@count_all_requests_and_posts = 0
		  @count_continuous_bad_requests = 0
			@count_posted = 0
			@count_rebloged = 0
			@count_followed = 0
			@sleep_before_client = false
			@sleep_before_follow_min = false
			@max_requests_and_posts = 50
			@max_posted = 30
			@max_reblogged = @max_posted
			@max_followed = @max_posted
    	config_client( hash_config ) if !hash_config.empty?
	  end

	  def config_client( hash_config )
	    hash_client = hash_config[HASH_CONFIG_CLIENT]
	    config_oauth( hash_client[HASH_CONFIG_CLIENT_OAUTH] )
	    stop_it!("'#{HASH_CONFIG_IS_RUNNING}' is False in config") if hash_client.has_key?( HASH_CONFIG_IS_RUNNING ) && !hash_client[HASH_CONFIG_IS_RUNNING]
	    @sleep_before_client = hash_client[HASH_CONFIG_SLEEP_BEFORE_CLIENT] if hash_client.has_key?( HASH_CONFIG_SLEEP_BEFORE_CLIENT )
	    @sleep_before_client_min = hash_client[HASH_CONFIG_SLEEP_BEFORE_CLIENT_MIN] if hash_client.has_key?( HASH_CONFIG_SLEEP_BEFORE_CLIENT_MIN )
	    @sleep_before_client_max = hash_client[HASH_CONFIG_SLEEP_BEFORE_CLIENT_MAX] if hash_client.has_key?( HASH_CONFIG_SLEEP_BEFORE_CLIENT_MAX )
	    @sleep_before_follow_min = hash_client[HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MIN] if hash_client.has_key?( HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MIN )
	    @sleep_before_follow_max = hash_client[HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MAX] if hash_client.has_key?( HASH_CONFIG_SLEEP_BEFORE_FOLLOW_MAX )
	    @max_requests_and_posts = hash_client[HASH_CONFIG_MAX_REQUESTS_AND_POSTS] if hash_client.has_key?( HASH_CONFIG_MAX_REQUESTS_AND_POSTS )
	    @max_posted = hash_client[HASH_CONFIG_MAX_POSTED] if hash_client.has_key?( HASH_CONFIG_MAX_POSTED )
	    @max_reblogged = hash_client[HASH_CONFIG_MAX_REBLOGGED] if hash_client.has_key?( HASH_CONFIG_MAX_REBLOGGED )
	    @max_followed = hash_client[HASH_CONFIG_MAX_FOLLOWED] if hash_client.has_key?( HASH_CONFIG_MAX_FOLLOWED )
	  end

	  def check_client_config
	  end

	 	def config_oauth( hash_oauth ) 
		  ::Tumblr.configure do |config|
			  config.consumer_key = hash_oauth[HASH_CONFIG_CLIENT_OAUTH_CONSUMER_KEY]
			  config.consumer_secret = hash_oauth[HASH_CONFIG_CLIENT_OAUTH_CONSUMER_SECRET]
			  config.oauth_token = hash_oauth[HASH_CONFIG_CLIENT_OAUTH_TOKEN]
			  config.oauth_token_secret = hash_oauth[HASH_CONFIG_CLIENT_OAUTH_TOKEN_SECRET]
			end
			@client = ::Tumblr::Client.new 		
	  end

	  # --- request and post ---
	  
	  def display_url_post( tumblr_url, post_id, is_short=false )
	    display_hash_post( get_hash_post(tumblr_url, post_id), is_short )
	  end
    
	  # tumblr_url must be xxxx.tumblr.com
	  # @todo check valid tumblr_url (not xxx.tumblr.compost or xxx.tumblr.com/post...)
	  def get_hash_post( tumblr_url, post_id )
	    CurateTumblr.format_tumblr_url!( tumblr_url )
	    tumblr_url = get_tumblr_domain if tumblr_url.empty?

	    hash_posts_multiple = client_get_posts( tumblr_url, post_id )
      return false if hash_posts_multiple.has_key?( "status" ) && !check_hash_status( hash_posts_multiple)
	    if !CurateTumblr.hash_multiple_posts_valid?( hash_posts_multiple )
	      log_tumblr.error "#{__method__} hash_posts_multiple #{hash_posts_multiple} are not valid for tumblr_url=#{tumblr_url} and post_id=#{post_id}"
	      return false 
	    end
      if hash_posts_multiple['posts'].count != 1
	      log_tumblr.error "#{__method__} hash_posts_multiple #{hash_posts_multiple} have not one element for tumblr_url=#{tumblr_url} and post_id=#{post_id}"
	      return false 
	    end
	    
      hash_post = hash_posts_multiple['posts'][0]
      if !CurateTumblr.hash_post_valid?( hash_post )
	      log_tumblr.error "#{__method__} hash_post #{hash_post} is not valid for tumblr_url=#{tumblr_url} and post_id=#{post_id}"
	      return false 
	    end
	    hash_post
	  end   

	  def get_post_global_options
	    if !@state
	      @state = POST_STATE_PUBLISH 
	      log_tumblr.warn( "state was empty, so posts will be published" )
	    end
	    options = { state: @state }
	    options.merge!( { tags: @infos_tags } ) if !@infos_tags.empty?  
	    options
	  end  
	      
	  def get_post_text_options( title, body )
	    { title: title, body: body }.merge( get_post_global_options )
	  end  
	    
	  def get_post_photos_options( photos_paths, caption='' )
	    { data: photos_paths, caption: caption }.merge( get_post_global_options )
	  end 
	            
	  def get_reblog_options( post_id, reblog_key )
	    { id: post_id, reblog_key: reblog_key, comment: @infos_caption }.merge( get_post_global_options )
	  end 

	  def get_id_post_if_ok( hash_id )
	    return false if !status_result( hash_id ) 
	    id = CurateTumblr.get_id_from_direct_post( hash_id )
	    if !CurateTumblr.post_id_valid?( id )
	      return return_error( __method__, "id is not valid", { id: id } )
	    end   
	    id
	  end

	  def sleep_before( seconds=false )
	    seconds = @sleep_before_client if !seconds
	    seconds = CurateTumblr.get_random_sleep( @sleep_before_client_min, @sleep_before_client_max ) if !seconds
	    sleep_print( seconds )
	  end
	    
	  def delete_post!( id ) 
	    client_delete_post!( id )
	    @ar_posted_id.delete( id )
	    true
	  end

    # --- tumblr api ---

	  def get_queue( limit='' )
	    @client.queue( get_tumblr_domain, {limit: limit} )
	  end

    def client_post_text( title, body )
      return false if !before_post
      id = get_id_post_if_ok( @client.text( get_tumblr_domain, get_post_text_options( title, body ) ) )
      after_posted( id )
    end
       
    def client_post_photos( photos_paths, caption='' )
      return false if !before_post
      id = get_id_post_if_ok( @client.photo( get_tumblr_domain, get_post_photos_options( photos_paths, caption ) ) ) 
      after_posted( id ) 
    end   
      
    def client_reblog( post_id, reblog_key )
      return false if !before_reblog
      id = get_id_post_if_ok( @client.reblog( get_tumblr_domain, get_reblog_options( post_id, reblog_key ) ) )        
      after_rebloged( id )
    end
      
    def client_follow( tumblr_url )
      return false if !before_follow
      result = status_result( @client.follow( tumblr_url ) )
      after_followed( result )
    end  
      
    def client_delete_post!( id )
      return false if !before_client( false )        
      result = @client.delete(get_tumblr_domain, id)
      after_deleted( result, id )
    end     

    def client_get_posts( tumblr_url, post_id )
      return false if !before_client( false )    
      result = @client.posts( tumblr_url, { :id => post_id } )
      after_get_posts( result )
    end

    # --- manage tumblr errors ---

	  def status_result( hash_status, is_display=true, is_log=true )
	    status_ok = get_status_if_ok( hash_status )
	    if status_ok
	      @count_continuous_bad_requests = 0 
	      return status_ok 
	    end
      check_hash_status( hash_status, is_display, is_log )
	    log_tumblr.error( "bad status result #{hash_status}" )
	    false
		end

    def check_hash_status( hash_status, is_display=true, is_log=true )
      return not_authorized( is_display, is_log ) if CurateTumblr.hash_status_not_authorized?( hash_status )
      return rate_limit_exceeded( is_display, is_log ) if CurateTumblr.hash_status_rate_limit?( hash_status )
      return bad_request( is_display, is_log ) if CurateTumblr.hash_status_bad_request?( hash_status )
      true
    end

		def get_status_if_ok( hash_status )
			return hash_status if !hash_status.is_a? Hash
		  return hash_status if !hash_status.has_key?( "status" )
		  return true if CurateTumblr.hash_status_ok?( hash_status )
		  false
		end      

	  def rate_limit_exceeded( is_display=true, is_log=true )
	    stop_and_alert( "Tumblr Rate Limit Exceeded, better wait one hour", is_display, is_log )
	    false
		end    

    def not_authorized( is_display=true, is_log=true )
      stop_and_alert( "Not authorized by Tumblr, please check oauth in the config file #{get_filename_config}", is_display, is_log )
      false
    end   

	  def bad_request( is_display=true, is_log=true )
	    @count_continuous_bad_requests += 1
	    if @count_continuous_bad_requests >= COUNT_ALERT_IF_TOO_MUCH_BAD_REQUESTS
	      message = "Too much (#{@count_continuous_bad_requests}) bad requests (perhaps the Tumblr queue is full)"
	      stop_and_alert( message, is_display, is_log ) 
	    end
	    false
		end  

		private

		  def sleep_print( seconds )
		    seconds = 1 if seconds <= 0 || !seconds
		    print DISPLAY_SLEEP_BEFORE if !DISPLAY_SLEEP_BEFORE.empty?
		    print seconds
		    sleep( seconds ) 
		    print DISPLAY_SLEEP_AFTER if !DISPLAY_SLEEP_AFTER.empty?
		  end		

		  def before_client( is_add_count=true )
		    config_from_yaml
				stop_it!("max (#{@count_all_requests_and_posts}) requests and posts") if @count_all_requests_and_posts >= @max_requests_and_posts
		    return false if !can_run?
		    sleep_before( @sleep_before_client )
		    @count_all_requests_and_posts += 1 if is_add_count
		    true
		  end    

		  def before_post
		    return false if !before_client
		    if @count_posted >= @max_posted
		      log_tumblr.warn( "posted maximum (#{@max_posted})")
		      return false
		    end 
		    true
		  end

		  def before_reblog
		    return false if !before_client
		    if @count_rebloged >= @max_reblogged
		      log_tumblr.warn( "reblogged maximum (#{@max_reblogged})")
		      return false
		    end 
		    true
		  end	

		  def before_follow
		    return false if !before_client
		    if @count_followed >= @max_followed
		      log_tumblr.warn( "followed maximum (#{@max_followed})")
		      return false
		    end 
		    if @sleep_before_follow_min
	        sleep_print( CurateTumblr.get_random_sleep( @sleep_before_follow_min, @sleep_before_follow_max ) )
	      end
		    true
		  end	

			def after_published( id )
				all_published_id << id
				id
			end

			def after_posted( id )
			  return id if !id
				@count_posted += 1
		    print DISPLAY_TUMBLR_POST if id && !DISPLAY_TUMBLR_POST.empty?
				after_published( id )
			end

			def after_rebloged( id )
			  return id if !id
				@count_rebloged += 1
			  print " "+@count_rebloged.to_s + DISPLAY_TUMBLR_REBLOG + " " if !DISPLAY_TUMBLR_REBLOG.empty?
				after_published( id )
			end	

			def after_followed( result )
			  return result if !result
				@count_followed += 1
				print " " + @count_followed.to_s + DISPLAY_TUMBLR_FOLLOW + " " if !DISPLAY_TUMBLR_FOLLOW.empty?
				result
			end		

			def after_deleted( result, id )
			  return result if !result
		    print " " + DISPLAY_TUMBLR_DELETE + " " if !DISPLAY_TUMBLR_DELETE.empty?
		    all_published_id.delete( id )
				result
			end	

			def after_get_posts( result )
			  return result if !result
		    print " " + DISPLAY_TUMBLR_GETPOSTS + " " if !DISPLAY_TUMBLR_GETPOSTS.empty?
		    result
			end
    end
	end
end