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

set :css_dir, "stylesheets"
set :js_dir, "javascripts"
set :images_dir, "images"

activate :gzip

# set :slim, { pretty: true }

activate :s3_sync do |config|
  config.bucket                     = ENV["S3_BUCKET"]
  config.region                     = ENV["S3_REGION"]
  config.delete                     = false
  config.after_build                = false
  config.prefer_gzip                = true
  config.path_style                 = false
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
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
