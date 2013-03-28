module Autoversion
  class Versioner

    def initialize
      # Read the Versionfile
      versionfileContents = File.read File.join(Dir.pwd, "Versionfile")

      # Eval the Versionfile within the DSL
      @read_blk, @write_blk, @listeners = Autoversion::DSL.evaluate versionfileContents
      
      # Fetch current version?
      @current = read_version if @read_blk
    end

    def current_version
      @current
    end

    def next_version type
      @current.increment(type)
    end

    def increment! type
      nextVersion = @current.increment(type)
      write_version @current, nextVersion
      @current = nextVersion
    end

    def read_version
      Autoversion::SemVer.new @read_blk.call
    end

    def write_version currentVersion, nextVersion
      @write_blk.call currentVersion, nextVersion
    end

  end
end