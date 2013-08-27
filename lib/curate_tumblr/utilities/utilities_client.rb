module CurateTumblr
  
	def self.get_reblog_key_from_hash_post( hash_post )
	  return false if !hash_post_valid?( hash_post )
	  return false if !hash_post.has_key?( 'reblog_key' )
	  hash_post['reblog_key']
	end

	def self.get_id_from_direct_post( hash_id )
	  return false if !hash_id_valid?( hash_id )
	  hash_id['id']
	end	

	def self.get_hash_url_from_post_url( post_url )
		return false if !Tumblr::ExtractLinks.tumblr_post_url?( post_url )
		{ tumblr_url: Tumblr::ExtractLinks.get_tumblr_url( post_url ), post_id: Tumblr::ExtractLinks.get_post_id_from_post_url( post_url ) } 
	end
	 
	def self.get_hash_url_from_reblog_url( reblog_url )
		return false if !Tumblr::ExtractLinks.tumblr_reblog_url?( reblog_url )
		{ tumblr_url: Tumblr::ExtractLinks.get_tumblr_from_reblog_url( reblog_url ), post_id: Tumblr::ExtractLinks.get_post_id_from_reblog_url( reblog_url ) } 
	end 

	def self.get_source_from_hash_post( hash_post )
	  get_url_from_hash_post( "source_url", hash_post )
	end

	def self.get_link_url_from_hash_post( hash_post )
	  get_url_from_hash_post( "link_url", hash_post )
	end

	def self.get_url_from_hash_post( url_key, hash_post )
	  return false if !hash_post_valid?( hash_post )
	  return false if !hash_post.has_key?( url_key )
	  #return false if !tumblr_url?( hash_post[url_key] )
	  hash_post[url_key]
	end

	def self.hash_status_ok?( hash_status )
	  hash_status?( hash_status, CLIENT_STATUS_OK )
	end

	def self.hash_status_not_found?( hash_status )
	  hash_status?( hash_status, CLIENT_STATUS_NOT_FOUND )
	end

	def self.hash_status_rate_limit?( hash_status )
	  hash_status?( hash_status, CLIENT_STATUS_RATE_LIMIT )
	end

	def self.hash_status_bad_request?( hash_status )
	  hash_status?( hash_status, CLIENT_STATUS_BAD_REQUEST )
	end

  def self.hash_status_not_authorized?( hash_status )
    hash_status?( hash_status, CLIENT_STATUS_NOT_AUTHORIZED )
  end

	def self.hash_status?( hash_status, status )
	  return true if !hash_status.has_key?( "status" )
	  return true if hash_status["status"] == status
	  false
	end

	def self.get_random_sleep( min, max )
	  raise "min is empty" if !min
	  raise "max is empty" if !max
	  raise "min (#{min} is >=  max (#{max})" if min >= max
	  seconds = 1 + rand( max )
	  seconds = min if seconds < min
	  seconds
	end

	def self.display_hash_post( hash_post, is_short=false )
  	raise "hash_post #{hash_post} is not valid" if !hash_post_valid?( hash_post )
  	title = "#{hash_post['type']} in #{hash_post['blog_name']} (#{hash_post['note_count']})"
  	title = title + " (source #{hash_post['source_url']})" if hash_post.has_key?( 'source_url' )
  	puts title
  	return if is_short
  	hash_post.each do |key, value|
  	  puts "> #{key} : #{value}"
  	end
	end
	  
	def self.display_hash_multiple_posts( hash_posts, is_short=false )
	  raise "hash_posts #{hash_posts} is not valid" if !hash_multiple_posts_valid?( hash_posts )
	  hash_posts['posts'].each { |hash_post| display_hash_post( hash_post, is_short ) }
	end

	def self.get_summary_hash_post( hash_post )
	  return hash_post if !hash_post_valid?( hash_post )
	  summary = {}
	  copy_hash_key( hash_post, summary, "blog_name")
	  copy_hash_key( hash_post, summary, "id")
	  copy_hash_key( hash_post, summary, "type")
	  copy_hash_key( hash_post, summary, "post_url")
	  copy_hash_key( hash_post, summary, "slug")
	  copy_hash_key( hash_post, summary, "state")
	  copy_hash_key( hash_post, summary, "reblog_key")
	  summary
	end

	def self.copy_hash_key( hash_source, hash_target, key )
	  return false if !hash_source.has_key?( key )
	  hash_target[key] = hash_source[key]
	end
end	