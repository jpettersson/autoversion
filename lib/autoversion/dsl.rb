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