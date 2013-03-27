module Autoversion
  class Versioner

    def initialize
      @current = read_version
    end

    def increment_patch

    end

    def increment_minor

    end

    def increment_major

    end

    def roll_back
      # Roll back to the previous version
      # Need a record of changes?
    end

    private 

    def read_version
      # Read version from Versionfile block
    end

    def write_version semantic
      # Write version using Versionfile block
    end

  end
end