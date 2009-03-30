load_template "http://github.com/galfert/rails-templates/raw/master/base.rb"

plugin 'open_id_authentication', :git => 'git://github.com/rails/open_id_authentication', :submodule => true
plugin 'restful-authentication', :git => 'git://github.com/technoweenie/restful-authentication', :submodule => true

gem 'thoughtbot-paperclip', :source => 'http://gems.github.com'

generate("authenticated", "user session")

# Initialize submodules
git :submodule => "init"

# Commit everything
git :add => "."
git :commit => "-a -m 'Add extra packages'"