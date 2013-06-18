require 'sinatra'
require 'erb'

module Webdiag
  class Server < Sinatra::Base

    set :root, "#{File.dirname(__FILE__)}/../../"

    configure do
      Webdiag.tempdir = Dir.mktmpdir
      Webdiag.public = "#{settings.root}/public"
      Webdiag.root = settings.root
    end

    get '/' do
      erb :index
    end

    post '/create' do
      @diag = params[:diag]
      @diagtype = params[:diagtype]
      @diagram = Diagram.create(@diagtype, @diag)
      erb :index
    end

    get %r{/(.+.png)} do
      File.open("#{Webdiag.tempdir}/#{params[:captures].first}").read
    end

  end
end

