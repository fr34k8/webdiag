require 'json'

module Webdiag
  class Diagram

    attr_reader :id, :type, :diag

    class << self
      def create(diagtype, diag)
        diagram= Diagram.new diagtype, diag
        diagram.save
        diagram
      end

      def load(id)
        diagram = Diagram.new nil, nil, id
        diagram.read
        diagram
      end

      def image(id)
        diagram = Diagram.load id
        diagram.build
      end

      def list
        Webdiag.redis.keys "*"
      end
    end

    def initialize(diagtype = nil, diag = nil, id = nil)
      @id = id || Time.now.to_i
      @diagtype = diagtype
      @diag = diag
    end

    def build
      diag_file_path = diag_save
      png_file_path = "#{Webdiag.tempdir}/#{@id}.png"
      `#{execdiag} -f #{Webdiag.root}/.fonts/sawarabi-gothic-medium.ttf  -o "#{png_file_path}" "#{diag_file_path}"`
      file_load png_file_path
    end

    def save
      Webdiag.redis.set @id, { type: @diagtype, diag: @diag}.to_json
    end

    def read
      json = JSON.parse Webdiag.redis.get(@id)
      @diagtype = json["type"]
      @diag = json["diag"]
    end

    private
     def file_load id
       File.open(id).read
     end

     def diag_save
       file_path = "#{Webdiag.tempdir}/#{@id}.diag"
       fp = File.open(file_path, 'w+')
       fp.puts @diag
       fp.close
       file_path
     end

     def execdiag
       case @diagtype
       when 'blockdiag'
         'blockdiag'
       when 'seqdiag'
         'seqdiag'
       when 'actdiag'
         'actdiag'
       when 'nwdiag'
         'nwdiag'
       else
         'blockdiag'
       end
     end

  end
end
