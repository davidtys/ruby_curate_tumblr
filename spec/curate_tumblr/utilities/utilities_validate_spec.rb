require 'spec_helper'

describe "Utilities Validate" do 
  include_context "shared targets"

  describe "hash url" do
    it "must be valid" do
      hash_url = {:tumblr_url=>"terryrichardson.tumblr.com", :post_id=>"331417553"}

      CurateTumblr.post_id_valid?( hash_url[:post_id] ).should be_true
      CurateTumblr.hash_url_valid?( hash_url ).should be_true
    end
  end

  describe "post" do
    it "is post url" do
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( target_post_url ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( target_post_url2 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( target_post_url3 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( target_post_url4 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( target_post_url5 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( bad_target_post_url ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( bad_target_post_url2 ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( bad_target_post_url3 ).should be_false
    end    
  end
end  