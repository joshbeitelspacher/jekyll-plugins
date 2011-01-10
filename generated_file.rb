module Jekyll

  class GeneratedFile
    @@mtimes = Hash.new # the cache of last modification times [path] -> mtime

    # Initialize a new GeneratedFile.
    #   +site+ is the Site
    #   +name+ is the String filename of the source file
    #   +dest_name+ is the String filename of the destination filename
    #   +command+ is the lambda to run in order to generate the destination file
    #
    # Returns <GeneratedFile>
    def initialize(site, name, dest_name, command)
      @site = site
      @name = name
      @dest_name = dest_name
      @command = command
    end

    # Obtains source file path.
    #
    # Returns source file path.
    def path
      File.join(@site.source, @name)
    end

    # Obtain destination path.
    #   +dest+ is the String path to the destination dir
    #
    # Returns destination file path.
    def destination(dest)
      File.join(dest, @dest_name)
    end

    # Obtain mtime of the source path.
    #
    # Returns last modifiaction time for this file.
    def mtime
      File.stat(path).mtime.to_i
    end

    # Is source path modified?
    #
    # Returns true if modified since last write.
    def modified?
      @@mtimes[path] != mtime
    end

    # Write the generated file to the destination directory (if modified).
    #   +dest+ is the String path to the destination dir
    #
    # Returns false if the file was not modified since last time (no-op).
    def write(dest)
      dest_path = destination(dest)

      return false if File.exist? dest_path and !modified?
      @@mtimes[path] = mtime

      FileUtils.mkdir_p(File.dirname(dest_path))
      @command.call(dest)

      true
    end

    # Reset the mtimes cache (for testing purposes).
    #
    # Returns nothing.
    def self.reset_cache
      @@mtimes = Hash.new

      nil
    end
  end

end
