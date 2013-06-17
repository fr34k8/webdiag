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
      @png_path.gsub(Webdiag.public, '')
    end

    def save_diag(diag)
      path = "#{Webdiag.tempdir}/#{@filename}.diag"
      fp = File.open(path, 'w+')
      fp.puts diag
      fp.close
      path
    end

    def save
      `blockdiag -f /usr/share/fonts/japanese/TrueType/sazanami-gothic.ttf -o "#{Webdiag.public}/diag/#{@filename}.png" "#{@diag_path}"`
      @png_path = "#{Webdiag.public}/diag/#{@filename}.png"
    end

  end
end
