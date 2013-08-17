# coding: utf-8
require 'spec_helper'

describe "Extract" do 
  let(:curator) { FactoryGirl.build( :curator ) }

  include_context "shared targets"

  describe "from post url" do
    it "is tumblr from post url" do
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( target_post_url ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( target_post_url2 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( target_post_url3 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( target_post_url4 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( target_post_url5 ).should be_true
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( bad_target_post_url ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( bad_target_post_url2 ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.tumblr_url?( bad_target_post_url3 ).should be_false
    end

    it "get tumblr url from post url" do
      CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( target_post_url ).should eq( target_tumblr )
      CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( target_post_url2 ).should eq( target_tumblr )
      CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( target_post_url3 ).should eq( target_tumblr )
      CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( target_post_url4 ).should eq( target_tumblr )
      CurateTumblr::Tumblr::ExtractLinks.get_tumblr_url( target_post_url5 ).should eq( target_tumblr )
    end    

    it "get post id from post url" do
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( target_post_url ).should eq( target_post_id )
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( target_post_url2 ).should eq( target_post_id )
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( target_post_url3 ).should eq( target_post_id )
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( target_post_url4 ).should eq( target_post_id )
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( target_post_url5 ).should eq( target_post_id )
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( bad_target_post_url ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( bad_target_post_url2 ).should be_false
      CurateTumblr::Tumblr::ExtractLinks.get_post_id_from_post_url( bad_target_post_url3 ).should be_false
    end

    it "get source from hash" do
      tumblr_url = "disorder.tumblr.com"
      post_url = "http://disorder.tumblr.com/post/54774163481"
      post_id = 54774163481
      source_url = "http://c-isnenegro.tumblr.com/"

      hash_post = curator.get_hash_post( tumblr_url, 54774163481 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true
      CurateTumblr.get_source_from_hash_post( hash_post ).should eq( source_url )
    end
  end

  describe "external links" do
    it "get flickr link from caption1" do
      caption = %Q{
  <div class="caption">
  <p>
  <strong>
  Trapped by
  <a href="http://www.flickr.com/photos/dioneanu/9283622790/sizes/l/in/photostream/">Ioneanu</a>
  </strong>
  </p>
  <p>
  <a href="http://scalesofperception.tumblr.com/">SoP</a>
  - Scale of Environments
  </p>
  </div>
  </div>
    }
      link_captions = [ "www.flickr.com/photos/dioneanu/9283622790/sizes/l/in/photostream/" ]
      found_external_links = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( caption )
      found_external_links.count.should eq( link_captions.count )
      link_captions.each { |link| found_external_links.include?( link.chomp ).should be_true } 
    end

    it "get site link from caption2" do
      caption = %Q{
 <div class="caption">
<p>
<a class="tumblr_blog" href="http://onsomething.tumblr.com/post/51007662938" target="_blank">onsomething</a>
:
</p>
<blockquote>
<p>
<br/>
<a href="http://onsomething.tumblr.com/" title="onsomething" target="_blank">onsomething</a>
</p>
<blockquote>
<p>
<span class="st">
<strong>
<a href="http://www.nurilo.com/" target="_blank">Nuno Ribeiro Lopes</a>
</strong>
|
</span>
Volcano Interpretation Centre,
<span class="st">2003-08</span>
Capelinhos
</p>
</blockquote>
</blockquote>
</div>
    }
      link_captions = [ "www.nurilo.com/" ]
      found_external_links = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( caption )      
      found_external_links.count.should eq( link_captions.count )
      link_captions.each { |link| found_external_links.include?( link.chomp ).should be_true } 
    end    

    it "get site link from formatted caption2" do
      caption = %Q{<p><a class=\"tumblr_blog\" href=\"http://onsomething.tumblr.com/post/51007662938\" target=\"_blank\">onsomething</a>:</p>\n<blockquote>\n<p><br/><a href=\"http://onsomething.tumblr.com/\" title=\"onsomething\" target=\"_blank\">onsomething</a></p>\n<blockquote>\n<p><span class=\"st\"><strong><a href=\"http://www.nurilo.com/\" target=\"_blank\">Nuno Ribeiro Lopes</a></strong> | </span>Volcano Interpretation Centre, 
        <span class=\"st\">2003-08 </span>Capelinhos</p>\n</blockquote>\n</blockquote>}
      link_captions = [ "www.nurilo.com/" ]
      found_external_links = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( caption )      
      found_external_links.count.should eq( link_captions.count )
      link_captions.each { |link| found_external_links.include?( link.chomp ).should be_true } 
    end

    it "get external links from true post1" do
      ar_links_caption = [ "abandonedography.com/post/55211207965/the-boiler-room-by-sebastian-niedlich", 
        "www.flickr.com/photos/42311564@N00/9196902084/sizes/l/in/set-72157634452675984/" ]
      hash_post = curator.get_hash_post( "shhhgrrrl.tumblr.com", 55227142636 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true

      ar_tofollow = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( hash_post["caption"] )
      ar_tofollow.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| ar_tofollow.include?( link ).should be_true  }

      curator.all_external_links.count.should eq( 0 )
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.all_external_links.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| curator.all_external_links.include?( link ).should be_true  }
    end

    it "get external links from true target_post_url2" do
      ar_links_caption = [ "www.flickr.com/photos/signsign86523/3842128766/in/photostream/lightbox/" ]
      hash_post = curator.get_hash_post( "photonotdead.tumblr.com", 55109966565 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true

      ar_tofollow = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( hash_post["caption"] )
      ar_tofollow.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| ar_tofollow.include?( link ).should be_true  }

      curator.all_external_links.count.should eq( 0 )
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.all_external_links.count.should eq( ar_links_caption.count )
      ar_links_caption.each { |link| curator.all_external_links.include?( link ).should be_true  }
    end

    it "get tumblr and external links from true target_post_url1" do
      ar_tumblr_links_caption = [ "solitaria.tumblr.com" ]
      ar_external_links_caption = [ "www.flickr.com/photos/websterk3/7217711884/" ]

      hash_post = curator.get_hash_post( "boob-shark.tumblr.com", 55272431819 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true

      ar_external = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( hash_post["caption"] )
      ar_external.count.should eq( ar_external_links_caption.count )
      ar_external_links_caption.each { |link| ar_external.include?( link ).should be_true  }

      ar_tumblr = CurateTumblr::Tumblr::ExtractLinks.get_tumblr_urls_from_text( hash_post["caption"] )        
      curator.all_external_links.count.should eq( 0 )
      curator.all_tofollow_urls.count.should eq( 0 )
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.all_external_links.count.should eq( ar_external_links_caption.count )
      ar_external_links_caption.each { |link| curator.all_external_links.include?( link ).should be_true  }
      curator.all_tofollow_urls.count.should eq( ar_tumblr_links_caption.count )
      ar_tumblr_links_caption.each { |link| curator.all_tofollow_urls.include?( link ).should be_true  }
    end   

    it "get tumblr and external links from true target_post_url2" do
      File.delete( curator.get_filename_links ) if File.exists?( curator.get_filename_links )
      File.delete( curator.get_filename_tofollow ) if File.exists?( curator.get_filename_tofollow )
      File.delete( curator.get_filename_external_links ) if File.exists?( curator.get_filename_external_links )
      ar_tumblr_links_caption = [ "autopsi-art.tumblr.com" ]
      ar_external_links_caption = [ "fredblas.500px.com/home" ]

      hash_post = curator.get_hash_post( "shhhgrrrl.tumblr.com", 55467043185 )
      CurateTumblr.hash_post_valid?( hash_post ).should be_true

      ar_external = CurateTumblr::Tumblr::ExtractLinks.get_external_urls_from_text( hash_post["caption"] )
      ar_external.count.should eq( ar_external_links_caption.count )
      ar_external_links_caption.each { |link| ar_external.include?( link ).should be_true  }

      ar_tumblr = CurateTumblr::Tumblr::ExtractLinks.get_tumblr_urls_from_text( hash_post["caption"] )        
      curator.all_external_links.count.should eq( 0 )
      curator.all_tofollow_urls.count.should eq( 0 )
      curator.extract_links_caption_from_post( hash_post ).should be_true
      curator.all_external_links.count.should eq( ar_external_links_caption.count )
      ar_external_links_caption.each { |link| curator.all_external_links.include?( link ).should be_true  }
      curator.all_tofollow_urls.count.should eq( ar_tumblr_links_caption.count )
      ar_tumblr_links_caption.each { |link| curator.all_tofollow_urls.include?( link ).should be_true  }

      curator.add_tofollow_tofile.should be_true
      ar_tofollow = CurateTumblr.get_ar_from_file( curator.get_filename_tofollow )
      ar_tofollow.count.should eq( ar_tumblr_links_caption.count )
      ar_tumblr_links_caption.each { |link| ar_tofollow.include?( link + "\n" ).should be_true  }

      curator.add_externallinks_tofile.should be_true
      ar_external = CurateTumblr.get_ar_from_file( curator.get_filename_external_links )
      ar_external.count.should eq( ar_external_links_caption.count )
      ar_external_links_caption.each { |link| ar_external.include?( link + "\n" ).should be_true  }
    end   
  end
end    