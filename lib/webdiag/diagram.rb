module Webdiag
  class Diagram

    attr_accessor :filename, :diag_path, :png_path

    def self.create(diag)
      dialog = Diagram.new diag
      dialog.save
      dialog
    end

    def initialize(diag)
      @filename = Time.now.to_i
      @diag_path = save_diag(diag)
      @png_path = ""
    end

    def png
      @png_path
    end

    def save_diag(diag)
      path = "#{Webdiag.tempdir}/#{@filename}.diag"
      fp = File.open(path, 'w+')
      fp.puts diag
      fp.close
      path
    end

    def save
      `blockdiag -f #{Webdiag.root}/.fonts/sawarabi-gothic-medium.ttf  -o "#{Webdiag.tempdir}/#{@filename}.png" "#{@diag_path}"`
      @png_path = "#{@filename}.png"
    end

  end
end
