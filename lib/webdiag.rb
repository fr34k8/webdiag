require "webdiag/version"

module Webdiag

  class << self

    attr_accessor :tempdir, :public, :root, :redis

    def start(options)
      Server.run!(Options.load(options))
    end

  end

  require 'webdiag/server'
  require 'webdiag/options'
  require 'webdiag/diagram'
end
