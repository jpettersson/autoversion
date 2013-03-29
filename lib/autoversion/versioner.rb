module Autoversion
  class Versioner

    def initialize
      @simulate = true

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

    def increment! type, simulate
      nextVersion = @current.increment(type)

      process_before type, @current, nextVersion
      write_version @current, nextVersion unless simulate

      @current = nextVersion

      process_after type, @current
    end

    private 

    def read_version
      Autoversion::SemVer.new @read_blk.call
    end

    def write_version currentVersion, nextVersion
      @write_blk.call currentVersion, nextVersion
    end

    def process_before event, currentVersion, nextVersion
      notify_listeners :before, event, currentVersion, nextVersion
      notify_listeners :before, :version, currentVersion, nextVersion
    end

    def process_after event, currentVersion
      notify_listeners :after, event, currentVersion
      notify_listeners :after, :version, currentVersion
    end

    def notify_listeners type, event, *args
      @listeners.select{|l| l[:type] == type && l[:event] == event }.each do |listener|
        listener[:blk].call *args
      end
    end
  end
end