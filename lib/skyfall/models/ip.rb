module Skyfall
  class IP
    def initialize(opts = {})
      @address = opts.fetch(:address)
      @mac = opts.fetch(:mac_addr)
    end

    def self.find(address)
      Skyfall::ARPCache.ip_lookup(address)
    end

    def ping
      r = `ping -t1 -c1 #{@address}`
      [r, $?]
    end

    def alive?
      (ping.last.exitstatus == 0)
    end

  end
end
