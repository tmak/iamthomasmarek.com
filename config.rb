###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

helpers do
  def inline_stylesheet(path)
    content_tag :style do
      sprockets[path].to_s
    end
  end

  def sitemap_pages
    sitemap.resources.find_all{|page| page.ext == ".html" && page.data.sitemap_lastmod.present? && page.data.sitemap_changefreq.present? }
  end
end

set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

activate :minify_html

activate :s3_sync do |config|
  config.bucket                     = ENV["S3_BUCKET"]
  config.region                     = ENV["AWS_DEFAULT_REGION"]
  config.delete                     = false
  config.after_build                = false
  config.prefer_gzip                = true
  config.path_style                 = true
  config.reduced_redundancy_storage = false
  config.acl                        = "public-read"
  config.encryption                 = false
end

default_caching_policy max_age: 1576800000
caching_policy "application/xml", s_maxage: 1576800000, max_age: 0
caching_policy "text/html", s_maxage: 1576800000, max_age: 0
caching_policy "text/plain", s_maxage: 1576800000, max_age: 0

activate :cloudfront do |config|
  config.access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  config.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
  config.distribution_id =  ENV["CLOUDFRONT_DISTRIBUTION_ID"]
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css, inline: true

  # Minify Javascript on build
  activate :minify_javascript

  activate :favicon_maker, icons: {
    "favicon_template.png" => [
      { icon: "apple-touch-icon-152x152-precomposed.png" },
      { icon: "apple-touch-icon-144x144-precomposed.png" },
      { icon: "apple-touch-icon-120x120-precomposed.png" },
      { icon: "apple-touch-icon-114x114-precomposed.png" },
      { icon: "apple-touch-icon-72x72-precomposed.png" },
      { icon: "apple-touch-icon-57x57-precomposed.png" },
      { icon: "favicon.png", size: "64x64" },
      { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
    ]
  }

  # Enable cache buster
  activate :asset_hash, ignore: ["favicon_template.png"]

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  activate :gzip, exts: %w(.html .htm .js .css .svg .ico)
end
