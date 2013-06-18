module Webdiag
  class Diagram

    attr_accessor :filename, :diag_path, :png_path

    def self.create(diagtype, diag)
      dialog = Diagram.new diagtype, diag
      dialog.save
      dialog
    end

    def initialize(diagtype, diag)
      @diagtype = diagtype
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
      `#{execdiag} -f #{Webdiag.root}/.fonts/sawarabi-gothic-medium.ttf  -o "#{Webdiag.tempdir}/#{@filename}.png" "#{@diag_path}"`
      @png_path = "#{@filename}.png"
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
