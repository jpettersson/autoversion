module Autoversion
  class DSL
    class MissingReadBlock < Exception
    end

    class InvalidGitConfig < Exception
    end

    attr_accessor :read_blk
    attr_accessor :write_blk
    attr_accessor :listeners
    attr_accessor :config

    def initialize
      @read_blk = nil
      @write_blk = nil
      @listeners = []
      @config = {
        :git => {
          :actions => [],
          :prefix => '',
          :stable_branch => 'master'
        }
      }
    end

    # Parse the specified file with the provided matcher.
    #
    # The first returned match will be used as the version.
    def parse_file path, matcher
      File.open(path) do |f|
        f.each do |line|
          if m = matcher.call(line)
            return m
          end
        end
      end

      raise "#{path}: found no matching lines."
    end

    # Update a file naively matching the specified matcher and replace any
    # matching lines with the new version.
    def update_file path, matcher, currentVersion, nextVersion
      temp_path = "#{path}.autoversion"

      begin
        File.open(path) do |source|
          File.open(temp_path, 'w') do |target|
            source.each do |line|
              if matcher.call(line)
                target.write line.gsub currentVersion.to_s, nextVersion.to_s
              else
                target.write line
              end
            end
          end
        end

        File.rename temp_path, path
      ensure
        File.unlink temp_path if File.file? temp_path
      end
    end

    # Convenience function for update_file to apply to multiple files.
    def update_files paths, matcher, currentVersion, nextVersion
      paths.each do |path|
        update_file path, matcher, currentVersion, nextVersion
      end
    end

    def validate!
      # A read_version block is required
      raise MissingReadBlock unless @read_blk
      raise InvalidGitConfig if @config[:git][:actions].include?(:tag) && !@config[:git][:actions].include?(:commit)
    end

    def automate_git *args
      if args.length == 0
        @config[:git][:actions] = [:commit, :tag]
      else
        args[0].each do |arg| 
          if [:actions, :stable_branch, :prefix].include?(arg[0])
            @config[:git][arg[0]] = arg[1]
          end
        end
      end
    end

    # Register a block that will be used to read the 
    # version number from the current project.
    def read_version &blk
      @read_blk = blk
    end

    # Register a block that will be used to write the 
    # version number to the current project.
    def write_version &blk
      @write_blk = blk
    end

    # Register a block that will be executed after
    # a certain event has fired.
    def after event, &blk
      @listeners.push({
        :type => :after,
        :event => event,
        :blk => blk
      })
    end

    # Register a block that will be executed before
    # a certain event has fired.
    def before event, &blk
      @listeners.push({
        :type => :before,
        :event => event,
        :blk => blk
      })
    end

    class << self
      def evaluate(script)
        obj = self.new
        obj.instance_eval(script)
        obj.validate!

        return obj.read_blk, obj.write_blk, obj.listeners, obj.config
      end
    end
  end
end
