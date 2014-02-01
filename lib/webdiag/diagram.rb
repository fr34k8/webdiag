require 'json'
require 'open3'

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

      def update(diagtype, diag, id)
        diagram = Diagram.new diagtype, diag, id
        diagram.save
        diagram
      end

      def image(id)
        diagram = Diagram.load id
        diagram.build
      end

      def build_result(id)
        f = File.open("#{Webdiag.tempdir}/#{id}.result", "r")
        f.read
      end

      def list
        Webdiag.redis.keys "*"
      end

      def delete(id)
        Webdiag.redis.del id
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
      build_result, status = Open3.capture2e("#{execdiag} -f #{Webdiag.root}/.fonts/sawarabi-gothic-medium.ttf  -o \"#{png_file_path}\" \"#{diag_file_path}\"")
      build_result_save build_result
      begin
        file_load png_file_path
      rescue
        build_result_save $!
        file_load "public/img/error.png" 
      end
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

     def build_result_save build_result
       file_path = "#{Webdiag.tempdir}/#{@id}.result"
       fp = File.open(file_path, 'w+')
       fp.puts build_result
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
