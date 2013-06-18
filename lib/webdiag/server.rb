require 'sinatra'
require 'erb'
require 'uri'
require 'redis'

module Webdiag
  class Server < Sinatra::Base

    set :root, "#{File.dirname(__FILE__)}/../../"

    configure do
      uri = URI.parse(ENV["REDISTOGO_URL"])

      Webdiag.tempdir = Dir.mktmpdir
      Webdiag.root = settings.root
      Webdiag.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    end

    get '/' do
      @button = "create"
      @diagram = Diagram.new
      @action = "create"
      erb :index
    end

    get '/list' do
      @diaglist = Diagram.list
      erb :list
    end

    post '/create' do
      diag = params[:diag]
      diagtype = params[:diagtype]
      diagram = Diagram.create(diagtype, diag)
      redirect "/#{diagram.id}"
    end

    get '/:id' do
      @diagram = Diagram.load params[:id]
      @button = "update"
      @action = @diagram.id
      erb :index
    end

    post '/:id' do
      diagram = Diagram.update(params[:diagtype], params[:diag], params[:id])
      redirect "/#{diagram.id}"
    end

    get '/image/:id.png' do
      headers 'Content-Type' => 'image/png'
      Diagram.image params[:id]
    end

  end
end

