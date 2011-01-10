module Jekyll
  class SVGtoPNGConverter < Generator
    safe true
    priority :low

    # Scans the site source directory for all SVG files in private directories
    # (any top-level directory that starts with "_") and uses ImageMagick convert
    # to convert the files into PNG files in the site destination directory.
    #   +site+ is the Site
    #
    # Returns nothing.
    def generate(site)
      Dir.chdir(site.source) do
        Dir.glob(File.join('_*', '**', '*.svg')) do |source_image|
          dest_image = source_image.sub(/^_(.*)\.svg$/, '\1.png')
          command = lambda{|dest| system('convert', source_image, File.join(dest, dest_image))}
          site.static_files << GeneratedFile.new(site, source_image, dest_image, command)
        end
      end
    end

  end
end
