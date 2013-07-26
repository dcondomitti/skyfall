module Skyfall
  class User < ActiveRecord::Base
    has_many :addresses

    scope :by_name, ->(e) { where("LOWER(users.name) = LOWER(?)", e.to_s.strip).first }

    def pings
      addresses.inject([]) do |pings,address|
        pings << {
          address: address.address,
          time: Ping.redis.get(address.address)
        }
      end
    end
  end
end
