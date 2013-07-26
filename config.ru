require './lib/skyfall'
use Rack::Static, :urls => ['/css/stylesheets', '/javascripts'], :root => 'public'

run Skyfall::App
