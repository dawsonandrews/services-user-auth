require "user_auth/version"
require "user_auth/configuration"
require "user_auth/api"

module UserAuth
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
