require 'spec_helper'

describe CurateTumblr::Publish::Post do 
  include_context "shared targets"
  let(:curator) { FactoryGirl.build( :curator ) }

  before do
    File.open( curator.get_filename_links, 'w' ) { |file| file.puts "" }
  end
  
  describe "get infos post" do
    it "hash post from tumblr and id post" do
      hash_post = curator.get_hash_post( target_tumblr, target_post_id )      
      hash_post.should_not be_nil
      hash_post.should_not be_false
      hash_post.is_a?( Hash ).should be_true
      CurateTumblr.hash_post_valid?( hash_post ).should be_true
      hash_post["blog_name"].should eq( target_name )
      hash_post["id"].to_s.should eq( target_post_id )
    end

    it "extract hash url from post url" do
      hash_url = CurateTumblr.get_hash_url_from_post_url( target_post_url )
      hash_url.should be_true
      hash_url[:tumblr_url].should eq( target_tumblr )
      hash_url[:post_id].should eq( target_post_id )
    end

    it "no hash url from bad post url" do
      hash_url = CurateTumblr.get_hash_url_from_post_url( bad_target_post_url )
      hash_url.should be_false
    end
  end

  describe "post" do
    it "text" do
      curator.post_in_published
      curator.count_posted.should eq( 0 )
      curator.all_published_id.count.should eq( curator.count_posted )

      id = curator.post_text( get_post_title, get_post_text )
      id.should_not be_nil
      id.should be_true
      id.is_a?( Integer ).should be_true    
      curator.count_posted.should eq( 1 )
      curator.all_published_id.count.should eq( curator.count_posted )
    end
  end  
end