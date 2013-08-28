require 'factory_girl'

def get_tumblr_name
  "testitnowyeah14"
end

def get_tumblr_directory
  "/home/david/Dropbox/curate_tumblr"
end

FactoryGirl.define do
  factory :curator, class: CurateTumblr::Curator do
    initialize_with { CurateTumblr::Curator.new( get_tumblr_name, get_tumblr_directory ) }
  end

  factory :render_reblog, class: CurateTumblr::Render::RenderReblog do
    initialize_with { CurateTumblr::Render::RenderReblog.new( get_tumblr_name, get_tumblr_directory ) }
  end

  factory :render_follow, class: CurateTumblr::Render::RenderFollow do
    initialize_with { CurateTumblr::Render::RenderFollow.new( get_tumblr_name, get_tumblr_directory ) }
  end  
end

