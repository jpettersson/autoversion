module Autoversion
  class Versioner

    def initialize versionfileContents
      # Eval the Versionfile within the DSL
      @read_blk, @write_blk, @listeners = Autoversion::DSL.evaluate versionfileContents
      
      # Fetch current version?
      @current = read_version if @read_blk

      @git_enabled = false
      @gitter = ::Autoversion::Gitter.new(Dir.pwd)
    end

    def current_version
      @current
    end

    def next_version type
      @current.increment(type)
    end

    def increment! type, simulate=false
      nextVersion = @current.increment(type)

      process_before type, @current, nextVersion
      unless simulate
        write_version @current, nextVersion 
        @current = nextVersion
        @gitter.commit! type, @current.to_s if @git_enabled
      end

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