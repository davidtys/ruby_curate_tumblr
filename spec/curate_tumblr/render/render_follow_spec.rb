require 'spec_helper'

describe CurateTumblr::Render::RenderFollow do 
  let(:render_follow) { FactoryGirl.build( :render_follow ) }
  include_context "shared tumblrs"

  before do
    files_before( render_follow, tumblrs )
  end

  after do
    files_after( render_follow )
  end

  describe "initialize" do
    it "filename links" do
      File.exist?( render_follow.filename_links ).should be_true
      render_follow.get_links_torender_from_file.count.should eq( count_followed )
    end    
  end

  describe "render" do
    it "all tumblrs" do
     render_follow.render_links_from_file.should be_true 
     render_follow.get_count.should eq( count_followed )
     tumblrs_file = render_follow.get_links_torender_from_file
     tumblrs_file.empty?.should be_true
    end

    it "direct follow" do
      render = CurateTumblr.follow( get_tumblr_name, get_tumblr_directory, false )
      render.get_count.should eq( count_followed )
    end    
  end  
end  

