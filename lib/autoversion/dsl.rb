module Autoversion
  class DSL

    attr_accessor :read_blk
    attr_accessor :write_blk
    attr_accessor :event_listeners

    def initialize
      @read_blk = nil
      @write_blk = nil
      @event_listeners = []
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
      @event_listeners.push({
        :type => :after,
        :event => event,
        :blk => blk
      })
    end

    # Register a block that will be executed before
    # a certain event has fired.
    def before event, &blk
      @event_listeners.push({
        :type => :before,
        :event => event,
        :blk => blk
      })
    end

  end
end