# Rails template for initializing new projects
 
# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"

# Initialize git repository
git :init
 
# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"
 
# Add some common gems
gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem 'rubaidh-google_analytics', :lib => 'rubaidh/google_analytics', :source => 'http://gems.github.com'
initializer 'google_analytics.rb', "Rubaidh::GoogleAnalytics.tracker_id = 'TRACKER-ID'"

rake("gems:install", :sudo => true)

# Add plugins
plugin 'jrails', :git => 'git://github.com/aaronchi/jrails.git', :submodule => true
plugin 'asset_packager', :git => 'git://github.com/sbecker/asset_packager.git', :submodule => true
plugin 'hoptoad_notifier', :git => 'git://github.com/thoughtbot/hoptoad_notifier.git', :submodule => true
initializer 'hoptoad.rb', <<-END
HoptoadNotifier.configure do |config|
  config.api_key = 'HOPTOAD-KEY'
end
END

# Set up plugins, migrations, etc.
rake 'jrails:install:javascripts'
 
# Set up .gitignore
file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/application.yml
config/database.yml
db/*.sqlite3
END

capify!
run "curl -L http://github.com/galfert/rails-templates/raw/master/assets/deploy.rb > config/deploy.rb"

# Initialize submodules
git :submodule => "init"

# Commit everything
git :add => "."
git :commit => "-a -m 'Initial commit'"

puts "Success!"
puts "Now what?"
puts "Add your Google Analytics tracker id to 'config/initializers/google_analytics.rb'"
puts "Replace the line 'include ExceptionNotifiable' with 'include HoptoadNotifier::Catcher' in the ApplicationController"
puts "Add your Hoptoad API key to 'config/initializers/hoptoad.rb'"
