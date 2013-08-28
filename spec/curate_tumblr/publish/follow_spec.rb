require 'spec_helper'

describe CurateTumblr::Publish::Follow do 
  include_context "shared targets"
  include_context "shared links"
  include_context "shared tags"
  include_context "shared caption post"
  let(:curator) { FactoryGirl.build( :curator ) }

  before do
    File.open( curator.get_filename_links, 'w' ) { |file| file.puts "" }
  end
  
  describe "to follow after" do
  	it "should follow all links in caption when no source" do
      ar_links = curator.send( :add_tofollow_tumblr_links_from_caption, caption )
      ar_links.count.should eq( ar_links_caption_tumblrs.count )
      ar_links_caption_tumblrs.each { |link| ar_links.include?( link ).should be_true }
      curator.all_tofollow_urls.count.should eq( ar_links_caption_tumblrs.count )
    end

    it "should follow links in caption but not the source" do
      ar_links = curator.send( :add_tofollow_tumblr_links_from_caption, caption, source )
      ar_links_caption_tumblrs.each { |link| ar_links.include?( link ).should be_true }
      ar_links.count.should eq( ar_links_caption_tumblrs.count )
      curator.all_tofollow_urls.count.should eq( ar_links_caption_tumblrs.count - 1 )
    end   

    it "direct extract tumblr links in curation" do
      curator.all_tofollow_urls.count.should eq( 0 )
      curator.reblog_and_extract( link_follow )

      curator.count_rebloged.should eq( 1 )
      curator.all_tofollow_urls.count.should eq( count_caption_links_to_follow + 1 )
    end

    it "check tofollow tumblrs are not post urls" do
      ar_tofollow = get_random_ar_tumblrs( 4 )
      ar_tofollow.each do |link|
        CurateTumblr::Tumblr::ExtractLinks.simple_tumblr_url?( link ).should eq( true )
        CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( link ).should eq( true )
        CurateTumblr::Tumblr::ExtractLinks.tumblr_post_url?( link ).should eq( false )
      end
    end

    it "add tofollow tumblrs" do
    	ar_tofollow = get_random_ar_tumblrs( 4 )
    	ar_tofollow.each do |link|
    		curator.reblog_and_extract( link )
    	end
    	curator.all_tofollow_urls.count.should eq( ar_tofollow.count )
    	ar_tofollow.each { |link| curator.all_tofollow_urls.include?( link ).should be_true }
    end

    it "add tofollow from post tumblrs" do
    	ar_tofollow = [ "likeafieldmouse.tumblr.com", "mother-natureson.tumblr.com", "fuck-mefood.tumblr.com", "unpopuler.tumblr.com" ]
    	ar_tumblrs_posts = [ "http://likeafieldmouse.tumblr.com/post/56880391419/adrian-velazco", "http://likeafieldmouse.tumblr.com/post/56878573508/nicolai-howalt-boxers-before-and-after-the", "http://mother-natureson.tumblr.com/post/56880589244/unpopuler-my-blog-will-make-you-smile"]
    	ar_tumblrs_posts.each do |post|
    		curator.reblog_and_extract( post )
    	end
    	curator.all_tofollow_urls.count.should eq( ar_tofollow.count )
    	ar_tofollow.each { |link| curator.all_tofollow_urls.include?( link ).should be_true }
    end    
  end

  describe "add follow links to file" do
    it "puts links in file" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      
      count_follow = curator.count_followed
      urls_tofollow = [ "tofollow1.tumblr.com", "tofollow2.tumblr.com", "tofollow3.tumblr.com"]
      
      urls_tofollow.each { |url| curator.add_tofollow_url( url ) }
      curator.add_tofollow_tofile 
      
      File.exists?( curator.get_filename_tofollow ).should eq( true )
      all_tofollow_urls = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      all_tofollow_urls.count.should eq( urls_tofollow.count )
      urls_tofollow.each { |link| all_tofollow_urls.include?( link + "\n" ).should be_true }
    end

    it "keep links already in file" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      
      urls_tofollow = [ "tofollow1.tumblr.com", "tofollow2.tumblr.com", "tofollow3.tumblr.com"]
      urls_infile = [ "already1.tumblr.com", "already2.tumblr.com" ]

      File.open( curator.get_filename_tofollow, "w+" ) { |file| file.puts( urls_infile ) }
      CurateTumblr.get_ar_from_file( curator.get_filename_tofollow ).count.should eq( urls_infile.count )

      urls_tofollow.each { |url| curator.add_tofollow_url( url ) }
      curator.add_tofollow_tofile 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( urls_infile.count + urls_tofollow.count )
      urls_infile.each { |link| ar_tofollow.include?( link + "\n" ).should be_true }
      urls_tofollow.each { |link| ar_tofollow.include?( link + "\n" ).should be_true }
      curator.all_tofollow_urls.count.should eq( 0 )
    end        

    it "dont put link in file if already exists" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      
      urls_tofollow = [ "tofollow1.tumblr.com", "tofollow2.tumblr.com", "tofollow3.tumblr.com"]
      url_tonotfollow = "tofollow2.tumblr.com"

      File.open( curator.get_filename_tofollow, "w+" ) { |file| file.puts( url_tonotfollow ) }
      CurateTumblr.get_ar_from_file( curator.get_filename_tofollow ).count.should eq( 1 )

      urls_tofollow.each { |url| curator.add_tofollow_url( url ) }
      curator.add_tofollow_tofile 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( urls_tofollow.count )
      urls_tofollow.each { |link| ar_tofollow.include?( link + "\n" ).should be_true }
    end  
  end

	describe "follow" do  
		it "url" do
			curator.count_followed.should eq( 0 )
			curator.follow_url( "photonotdead.tumblr.com" )
			curator.count_followed.should eq( 1 )
		end
  end

  describe "from file" do
    it "put direct tofollow in file" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      File.open( curator.get_filename_tofollow, 'w' ) { }

      ar_links = curator.send( :add_tofollow_tumblr_links_from_caption, caption )
      curator.add_tofollow_tofile 
      ar_links.count.should eq( ar_links_caption_tumblrs.count ) 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( ar_links_caption_tumblrs.count )
      ar_links_caption_tumblrs.each { |link| ar_tofollow.include?( link + "\n" ).should be_true  }
    end   

    it "follow from a caption true post1" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      File.open( curator.get_filename_tofollow, 'w' ) { }

      ar_links_caption = ["afleshfesten.tumblr.com"]
      hash_post = curator.get_hash_post( "creve-coeur.tumblr.com", 49454185206 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.add_tofollow_tofile 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| ar_tofollow.include?( link + "\n" ).should be_true  }
    end

    it "follow from a caption true post2" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      File.open( curator.get_filename_tofollow, 'w' ) { }

      ar_links_caption = [ "photonotdead.tumblr.com", "classy-as-fcuk.tumblr.com", "crystvllized.tumblr.com", "worldofadvice.tumblr.com" ]

      hash_post = curator.get_hash_post( "photonotdead.tumblr.com", 55108093006 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.add_tofollow_tofile 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| ar_tofollow.include?( link + "\n" ).should be_true  }
    end

    it "follow from a caption true post3" do
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      File.open( curator.get_filename_tofollow, 'w' ) { }
        
      ar_links_caption = [ "we-melancholy-dreams.tumblr.com", "palejizz.tumblr.com", "sinnerer.tumblr.com" ]
      hash_post = curator.get_hash_post( "melancholicbeautyofsadness.tumblr.com", 55115100145 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.add_tofollow_tofile 

      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| ar_tofollow.include?( link + "\n" ).should be_true  }
    end
	end
end  