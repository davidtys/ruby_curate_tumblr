require 'spec_helper'

describe CurateTumblr::Tumblr::Client do 
	let(:curator) { FactoryGirl.build( :curator ) }
	subject { tumblr }
	include_context "shared targets"
	include_context "shared links"

  before do
    File.open( curator.get_filename_links, 'w' ) { |file| file.puts "" }
  end

	describe "status" do
	  it "when rate exceed" do
	    hash_status = get_status_rate_exceed
	    curator.is_stop.should be_false
	    curator.send( :status_result, hash_status, false, false )
	    curator.is_stop.should be_true
	  end

	  it "when status ok" do
	    hash_status = get_status_ok
	    curator.send( :status_result, hash_status, false, false).should be_true
	  end

	  it "when rate limit" do
	    hash_status = get_status_rate_exceed
	    CurateTumblr.hash_status_rate_limit?( hash_status ).should be_true
	    curator.send( :status_result, hash_status, false, false).should be_false
	  end
	end

	describe "post" do
		it "post a text" do
			id = curator.client_post_text( get_post_title, get_post_text )
		  id.should_not be_nil
		  id.should be_true
		  id.is_a?( Integer ).should be_true    
			curator.count_posted.should eq( 1 )
			curator.count_all_requests_and_posts.should eq( 1 )
		end

		it "stop all post" do
			curator.stop_it!
			curator.client_post_text( get_post_title, get_post_text ).should be_false
			curator.count_posted.should eq( 0 )
			curator.count_all_requests_and_posts.should eq( 0 )
		end		
	end	

 	describe "get infos post" do
	  it "hash post from tumblr and id post" do
	    hash_post = curator.send( :get_hash_post, target_tumblr, target_post_id )      
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
end