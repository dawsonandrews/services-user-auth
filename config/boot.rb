# Add current path and lib to the load path
$: << File.expand_path("../../", __FILE__)
$: << File.expand_path("../../lib", __FILE__)

# Default ENV to dev if not present
ENV["APP_ENV"] ||= "development"

# Autoload common standard library features
require "json"

# Autoload gems from the Gemfile
require "bundler/setup"
require "dotenv"

require "active_support/core_ext/object/blank" # blank? and present?
require "active_support/core_ext/integer/time" # 1.week.ago etc
require "active_support/core_ext/hash/slice" # params.slice(:one, :other)
require "active_support/core_ext/hash/conversions" # params.symbolize_keys
require "active_support/core_ext/hash/indifferent_access"

# Load dev env vars
Dotenv.load if %w[development test].include? ENV["APP_ENV"]

# Autoload app dependencies
path = File.join(__dir__, "initializers", "*.rb")
(Dir[path].sort).uniq.each { |rb| require rb }
