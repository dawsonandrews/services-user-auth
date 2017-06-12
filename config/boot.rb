# Add current path and lib to the load path
$: << File.expand_path("../../", __FILE__)
$: << File.expand_path("../../lib", __FILE__)

# Default ENV to dev if not present
ENV["APP_ENV"] ||= "development"

require "da/core/environment"
require "da/db"
require "da/web"

# Autoload app dependencies
path = File.join(__dir__, "initializers", "*.rb")
(Dir[path].sort).uniq.each { |rb| require rb }
