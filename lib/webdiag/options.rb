require 'optparse'

module Webdiag
  class Options < Hash

    def self.load(options)
      option = new({})
      op = OptionParser.new
      op.on('-p','--port VAL'){ |v| option[:port] = v}
      op.on('-b','--bind VAL'){ |v| option[:bind] = v}
      op.parse! options
      option
    end

  end
end

