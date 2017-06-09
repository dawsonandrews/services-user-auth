require "ostruct"

class ArrayMailer
  def initialize
    @queue = []
  end

  def deliver(options)
    @queue << OpenStruct.new(options)
  end

  def last_email
    @queue.last
  end

  def all
    @queue
  end

  def reset
    @queue = []
  end
end
