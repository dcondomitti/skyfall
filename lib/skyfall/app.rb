module Skyfall
  class App < Sinatra::Application
    register Sinatra::ActiveRecordExtension

    before do
      content_type 'text/plain'
    end

    get '/' do
      User.all.to_yaml
    end

    get %r{/users/(\d+)} do
      User.find(params[:captures].first).to_yaml
    end

    get %r{/users/(\d+)/pings} do
      User.find(params[:captures].first).pings.to_yaml
    end

    get %r{/users/(\w+)/?$} do
      User.by_name(params[:captures].first).to_yaml
    end

    get %r{/users/(\w+)/pings} do
      User.by_name(params[:captures].first).pings.to_yaml
    end

    get %r{/users/(\w+)/alive} do
      User.by_name(params[:captures].first).pings.sort { |n1,n2| n1[:time] <=> n2[:time] }.last[:time]
    end
  end
end
