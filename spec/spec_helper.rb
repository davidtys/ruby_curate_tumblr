require 'rspec'
require 'set'
require 'random-word'

require './lib/curate_tumblr'
require 'factories'
require 'shared_values'
require 'shared_examples'

def get_tumblr_test_tags
  "photo, test"
end  

def get_tumblr_test_title
  "<b>*" + RandomWord.adjs.next + " " + RandomWord.nouns.next + "*</b> " + Time.now.localtime.strftime("%H:%m") 
end	

def get_post_title
  "Post " + Time.now.localtime.strftime("%H:%m")
end

def get_post_text
  RandomWord.nouns.next + " " + RandomWord.nouns.next + " " + RandomWord.nouns.next
end

def get_config_filename
  "test_config.yaml"
end

def get_random_config_hash
  hash_config = {}
  hash_config.merge!( CurateTumblr::Tumblr::Client::get_client_config_hash( RandomWord.nouns.next, RandomWord.nouns.next, RandomWord.nouns.next, RandomWord.nouns.next ) )
  hash_config.merge!( CurateTumblr::Tumblr::Infos::get_infos_config_hash )
  hash_config
end

def get_random_ar_tumblrs( count )
  ar_tumblrs = []
  count.times do 
    ar_tumblrs << RandomWord.nouns.next + ".tumblr.com"
  end
  ar_tumblrs
end

def get_random_id_post
  id = ""
  6.times { id += rand(9).to_s }
  id
end

def get_random_ar_posts_from_tumblrs( ar_tumblrs )
  ar_tumblrs_posts = []
  ar_tumblrs.each { |link| ar_tumblrs_posts << link + "/post/" + get_random_id_post }
  ar_tumblrs_posts
end

def display_infos( curator )
  if curator.sandbox?
    puts "\n*** SANDBOX : no post will be sent to tumblr (nothing will be published) ***"
  else
    if curator.state.match( CurateTumblr::POST_STATE_QUEUE )
      str_state = 'IN QUEUE (not visible in blog, please CHECK queue will not be full !)'
      warning = "if all tests fail, please check there is enough space in #{curator.domain} queue"
    else
      str_state = 'published'
      warning = "if all tests fail, please check you have not published 100 posts today in #{curator.domain}"
   end 
    puts "\nTests from post will be #{str_state} in #{curator.domain}\n(wait #{curator.sleep_before_post_sec}sec before each post) (links in #{curator.filename_links})"
  end
end

def files_before( render, links='' )
  File.delete( render.filename_links ) if File.exists?( render.filename_links )
  File.open( render.filename_links, 'w' ) { |file| file.puts links }
end  

def files_after( render )
  File.delete( render.filename_links ) if File.exists?( render.filename_links )
end

def get_status_rate_exceed
  { "status" => 429, "msg" => "Rate Limit Exceeded" }  
end

def get_status_ok
  {"status"=>200, "msg"=>"Ok"} # in real when ok receive hash of post, not a status
end

def test_post_hash_contains_tags( hash_post, ar_tags )
  CurateTumblr::Utils.hash_post_valid?( hash_post ).should be_true
  hash_post.has_key?("tags").should be_true
  hash_post["tags"].is_a?( Array ).should be_true
  hash_post["tags"].count.should eq( ar_tags.count )
  ar_tags.each { |tag| hash_post["tags"].include?( tag ).should be_true }
end
