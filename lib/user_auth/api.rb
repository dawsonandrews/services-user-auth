require_relative "../../config/boot"
require "sinatra/base"

module UserAuth
  class Api < Sinatra::Base
    before { content_type(:json) }

    get "/" do
      json(hello: "world")
    end

    post "/signup" do
    end

    def json(data)
      JSON.dump(data)
    end
  end
end
