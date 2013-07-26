Bundler.require(:default)
require 'yaml'
require 'base64'

require "sinatra/activerecord"
set :database, "sqlite3:///skyfall.sqlite3"

module Skyfall
  def self.root
    (Pathname.new(File.dirname(__FILE__)) + '..').realpath
  end

  def self.update
    a = Skyfall::ARPCache.update
    Skyfall::Address.update_all
  end
end

Redised.redised_config_path = File.join(Skyfall.root, 'config', 'redis.yml')
Redised.redised_env = ENV['RACK_ENV'] || 'development'

require_relative 'skyfall/models/address'
require_relative 'skyfall/models/ping'
require_relative 'skyfall/models/user'
require_relative 'skyfall/models/ip'
require_relative 'skyfall/models/arp_cache'

require_relative 'skyfall/app'
