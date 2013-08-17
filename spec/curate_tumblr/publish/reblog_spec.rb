require 'spec_helper'

describe CurateTumblr::Publish::Reblog do 
  include_context "shared targets"
  include_context "shared links"
  include_context "shared tags"
  let(:curator) { FactoryGirl.build( :curator ) }

  describe "reblog link" do
    let(:tumblr_url) { "youknow-thisistheend.tumblr.com" }
    let(:post_url) {  "http://youknow-thisistheend.tumblr.com/post/54773810226/facebook-auf-we-heart-it" }
    let(:post_reblog_url) {  "http://www.tumblr.com/reblog/54773810226/HXKbdnPG?redirect_to=http%3A%2F%2Fterryrichardson.tumblr.com%2Fpost%2F221532252&source=iframe" }
    let(:post_id) {  "54773810226" }
    let(:post_reblog_key) {  "HXKbdnPG" }

    context "direct reblog url" do
      it "hash post from reblog url" do
        post_reblog_id = CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_reblog_url( post_reblog_url )
        post_reblog_id.should eq( post_id )
        
        hash_post = curator.get_hash_post( tumblr_url, post_id )
        CurateTumblr.hash_post_valid?( hash_post ).should be_true
        hash_post["id"].to_s.should eq( post_reblog_id )
    
        reblog_key1 = CurateTumblr.get_reblog_key_from_hash_post( hash_post )   
        reblog_key1.should eq( post_reblog_key )
        
        reblog_key2 = CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url( post_reblog_url )      
        reblog_key2.should eq( post_reblog_key )
        
        curator.send( :reblog_post_key, post_reblog_id, reblog_key2 ).should be_true  
      end

      it "get post id 1" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_reblog_url( target_reblog_url )
        id.should eq ( target_reblog_id )
      end

      it "get reblog key 1" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url( target_reblog_url )
        id.should eq ( target_reblog_key )
      end
      
      it "reblog  1" do
        count = curator.count_rebloged
        id = curator.reblog_and_extract( target_reblog_url )
        id.should_not be_nil
        id.should be_true
        id.is_a?( Integer ).should be_true              
        curator.count_rebloged.should eq( count+1 )
        curator.all_published_id.count.should eq( curator.count_rebloged )
      end

      it "get post id 2" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_reblog_url( target_reblog_url2 )
        id.should eq ( target_reblog_id2 )
      end
          
      it "get reblog key 2" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url( target_reblog_url2 )
        id.should eq ( target_reblog_key2 )
      end
              
      it "reblog 2" do
        count = curator.count_rebloged
        id = curator.reblog_and_extract( target_reblog_url2 )    
        id.should_not be_nil
        id.should be_true
        id.is_a?( Integer ).should be_true              
        curator.count_rebloged.should eq( count+1 )
        curator.all_published_id.count.should eq( curator.count_rebloged )
      end
     
      it "get post id 3" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_reblog_url( target_reblog_url3 )
        id.should eq ( target_reblog_id3 )
      end
    
      it "get reblog key 3" do
        id = CurateTumblr::Tumblr::ExtractLinks.get_reblog_key_from_reblog_url( target_reblog_url3 )
        id.should eq ( target_reblog_key3 )
      end
          
      it "reblog 3" do
        count = curator.count_rebloged
        id = curator.reblog_and_extract( target_reblog_url3 )    
        id.should_not be_nil
        id.should be_true
        id.is_a?( Integer ).should be_true              
        curator.count_rebloged.should eq( count+1 )    
        curator.all_published_id.count.should eq( curator.count_rebloged )
      end
  end


  context "from url link" do
    it "get url source from post" do
      url_tumblr = "marseraki.tumblr.com"
      id_post = "55357197864"
      url_source = "http://d-rogue.tumblr.com"
      hash_post = curator.get_hash_post( url_tumblr, id_post )
      hash_post.should be_true
      CurateTumblr.get_source_from_hash_post( hash_post ).should eq( url_source )
    end

    it "get url link from post" do
      url_tumblr = "marseraki.tumblr.com"
      id_post = "55357197864"
      url_link = "http://cutbeneathourhands.tumblr.com/"
      hash_post = curator.get_hash_post( url_tumblr, id_post )
      hash_post.should be_true
      CurateTumblr.get_link_url_from_hash_post( hash_post ).should eq( url_link )
    end  
  end


  end  
end
