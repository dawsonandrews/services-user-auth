require "bundler/gem_tasks"
require "da/rake_tasks"

# Add current path and lib to the load path
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

task default: ["ci:all"]
