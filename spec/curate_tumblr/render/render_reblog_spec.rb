require 'spec_helper'

describe CurateTumblr::Render::RenderLinks do 
  let(:render_reblog) { FactoryGirl.build( :render_reblog ) }
  include_context "shared links"

  before do
    files_before( render_reblog, links )
  end

  after do
    files_after( render_reblog )
  end

  describe "initialize" do
    it "filename links" do
      File.exist?( render_reblog.filename_links ).should be_true
      render_reblog.get_links_torender_from_file.count.should eq( count_reblogs )
    end    
  end

  describe "get reblog links from file" do
    it "read links" do
      ar_file = render_reblog.get_links_torender_from_file
      ar_file.should_not be_nil
      ar_file.class.should eq( Array )
      ar_file.count.should eq( links.lines.count )
    end   

    context "add links in random" do
      let(:links) { Set.new [ "1.tumblr.com", "2.tumblr.com", "3.tumblr.com", "4.tumblr.com", "5.tumblr.com", "6.tumblr.com" ] }

      it "order must be in random" do
        render_reblog.reboot!
        render_reblog.add_links_to_render( links.to_a )
        test1 = render_reblog.links_to_render
        test1.count.should eq ( links.count )
        test1.to_a.should_not eq( links.to_a )

        render_reblog.reboot!
        render_reblog.add_links_to_render( links.to_a )
        test2 = render_reblog.links_to_render
        test2.count.should eq ( links.count )
        test2.should_not eq( links.to_a )
        test2.to_a.should_not eq( test1.to_a )
      end

      it "each link must be uniq" do
        render_reblog.reboot!
        render_reblog.add_links_to_render( links )
        render_reblog.add_links_to_render( links )
        render_reblog.links_to_render.count.should eq( links.count )
      end
    end
  end

  describe "render" do

    it "all links" do
     render_reblog.render_links_from_file.should be_true 
     render_reblog.get_count.should eq( count_reblogs )
     render_reblog.get_all_published_id.count.should eq( count_reblogs )
     links_file = render_reblog.get_links_torender_from_file
     links_file.empty?.should be_true
    end

    it "direct reblog" do
      render = CurateTumblr.reblog( get_tumblr_name, get_tumblr_directory, false )
      render.get_count.should eq( count_reblogs )
    end
  end
end

