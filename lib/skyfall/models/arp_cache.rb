module Skyfall
  class ARPCache
    include ::Redised
    redised_namespace 'arp_cache'

    Entry = Struct.new(:hostname, :ip_address, :ethernet_address)

    def self.parse
      res = @raw_table.scan /(?<hostname>\?|[^\s]+) \((?<ip_address>[^\)]+)\) at (?<ethernet_address>[^\s]+) on/
      entries = res.inject([]) do |entries,row|
        entries << Entry.new(*row)
      end
      @table = entries
    end

    def self.store
      self.redis.set('table', YAML.dump(@table))
    end

    def self.table
      t = YAML.load(redis.get('table'))
      return t if t
      load
    end

    def self.update
      broadcast
      @raw_table = `arp -a`
      load
    end

    def self.load
      parse
      store
      @table
    end

    def self.by_mac(addr)
      table.each do |e|
        return e if e.ethernet_address == addr
      end
      false
    end

    def self.by_ip(ip)
      table.each do |e|
        return e if e.ip_address == addr
      end
      false
    end

    def self.broadcast
      `ping -c5 255.255.255.255`
    end

  end
end
