module Skyfall
  class Ping
    include ::Redised
    redised_namespace 'pings'

    attr_accessor :address

    def initialize(opts = {})
      @address = opts.fetch(:address, nil)
      @time = Time.now
    end

    def save
      self.redis.set(@address, @time)
    end
  end
end