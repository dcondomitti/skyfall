module Skyfall
  class Address < ActiveRecord::Base
    belongs_to :user

    def self.update
      self.all.map { |address| address.update }
    end

    def checkin
      p = Ping.new(address: self.address).save
    end

    def self.update_all
      self.all.each do |address|
        e = Skyfall::ARPCache.by_mac(address.address)
        if e
          puts "Checking #{e.ip_address} at #{address.address} for #{address.user.name}"
          if Skyfall::IP.new(address: e.ip_address, mac_addr: address.address).alive?
            puts "#{address.address} is alive as #{e.hostname}, saving ping"
            address.checkin
          end
        end
      end
    end

    def ip_address
      Skyfall::ARPCache.by_mac(self.address)
    end
  end
end
