require 'git'

module Autoversion
  class Gitter

    class DirtyStaging < Exception 
    end
    
    class NotOnStableBranch < Exception 
    end

    def initialize path, config
      @path = path
      @config = config
      @repo = Git.open(path)
    end

    def ensure_cleanliness!
      if @config[:actions].include?(:commit)
        raise DirtyStaging unless dir_is_clean?
      end
    end

    def dir_is_clean?
      @repo.status.untracked.length + @repo.status.added.length + @repo.status.changed.length + @repo.status.deleted.length == 0
    end

    def on_stable_branch?
      @repo.current_branch == @config[:stable_branch].to_s
    end

    def commit! versionType, currentVersion
      return false unless @config[:actions].include?(:commit)
      raise NotOnStableBranch if versionType == :major && !on_stable_branch?

      write_commit currentVersion
      write_tag currentVersion if @config[:actions].include?(:tag)
    end

    private

    def write_commit version
      @repo.add '.'
      @repo.commit "#{@config[:prefix]}#{version}"
    end

    def write_tag version
      @repo.add_tag "#{@config[:prefix]}#{version}"
    end

  end
end