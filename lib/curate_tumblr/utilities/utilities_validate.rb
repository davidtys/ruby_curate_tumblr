module CurateTumblr
  def self.hash_multiple_posts_valid?( hash_posts )
    return false if hash_posts.nil? 
    return false if !hash_posts.is_a? Hash
    return false if !hash_posts.has_key?( 'posts' )
    return false if !hash_posts['posts'].is_a? Array
    true
  end
  
  def self.hash_post_valid?( hash_post )
    return false if !hash_post
    return false if !hash_post.is_a?( Hash )
    return false if !hash_post.has_key?( 'blog_name' )
    return false if !hash_post.has_key?( 'id' )
    true
  end

  def self.hash_id_valid?( hash_id )
    return false if !hash_id.is_a? Hash
    return false if !hash_id.has_key?( 'id' )    
    return false if !post_id_valid?( hash_id['id'] )    
    true
  end
    
  def self.hash_url_valid?( hash_url )
    return false if !hash_url.is_a? Hash
    return false if !hash_url.has_key?( :tumblr_url )    
    return false if !hash_url.has_key?( :post_id )
    return false if !post_id_valid?( hash_url[:post_id] )    
    true    
  end    

  def self.check_paths_ar_photos( ar_photos )
    ar_photos.each do |path|
      raise "path #{path} doesn't exist" if !File.exist?( path )
    end
  end   

  def self.post_id_valid?( post_id )
    return false if post_id.nil?
    return false if !post_id
    return false if post_id.is_a?( String ) && post_id.empty?
    return false if post_id.is_a?( Integer ) && post_id.to_s.empty?
    true
  end

  def self.reblog_key_valid?( reblog_key )
    return false if reblog_key.nil?
    return false if !reblog_key
    return false if !reblog_key.is_a? String
    return false if reblog_key.empty?
    true
  end    
end    