module CurateTumblr

  def self.get_format_ar_tumblrs_urls( ar_tumblrs_urls )
    raise "ar_tumblrs_urls is a #{ar_tumblrs_urls.class} instead of Array" if !ar_tumblrs_urls.is_a? Array
    ar_new_tumblrs_urls = []
    ar_tumblrs_urls.each do |tumblr|
      format_tumblr_url!( tumblr )
      ar_new_tumblrs_urls << tumblr
    end
    ar_new_tumblrs_urls
  end    

  def self.get_format_tumblr_urls( tumblr_urls )
    if tumblr_urls.is_a? Set
      new_tumblr_urls = Set.new
    else
      new_tumblr_urls = []
    end
    tumblr_urls.each do |url|
      new_url = url.dup
      format_tumblr_url!( new_url )
      new_tumblr_urls << new_url
    end
    new_tumblr_urls
  end

  def self.get_format_urls( urls )
    if urls.is_a? Set
      new_urls = Set.new
    else
      new_urls = []
    end
    urls.each do |url|
      new_url = url.dup
      format_url!( new_url )
      new_urls << new_url
    end
    new_urls
  end

  def self.format_url!( url )
    url.gsub!("target=\"_blank\"", "")
    url.gsub!("href=\"", "")
    url.gsub!("http://", "")
    url.gsub!("https://", "")
    url.gsub!("http%3A%2F%2F", "")
    url.gsub!("\"", "")
    url.gsub!('"', "")
    url.chomp!
    url.chomp!( " " )
    url.lstrip!
  end 
  
  def self.get_format_ar_urls( ar_urls )
    raise "ar_urls is a #{ar_urls.class} instead of Array" if !ar_urls.is_a? Array
    ar_new_urls = []
    ar_urls.each do |url|        
      format_url!( url )
      ar_new_urls << url
    end
    ar_new_urls
  end       

  def self.get_format_ar_tumblr_urls( ar_urls )
    raise "ar_urls is a #{ar_urls.class} instead of Array" if !ar_urls.is_a? Array
    ar_new_urls = []
    ar_urls.each do |url|        
      format_tumblr_url!( url )
      ar_new_urls << url
    end
    ar_new_urls
  end 

  def self.format_tumblr_url!( tumblr_url )
    format_url!( tumblr_url )
    tumblr_url.gsub!("tumblr.com/", "tumblr.com")
    tumblr_url.gsub!("class=\"tumblr_blog\"", "")
    tumblr_url.gsub!("tumblr_blog href=", "")
    tumblr_url.gsub!("tumblr_blog", "")
    tumblr_url.gsub!("post", "")
    tumblr_url.gsub!("www.", "")
  end     

  def self.format_post_id( post_id )
    post_id.gsub('/', '').chomp.strip  
  end
  
  def self.format_post_reblog_key( key )
    key.gsub('/', '').gsub('?', '').chomp.strip  
  end          
end    