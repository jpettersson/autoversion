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
      sum = gitstatus_untracked_workaround.length +
            @repo.status.added.length +
            @repo.status.changed.length +
            @repo.status.deleted.length

      if sum > 0
        puts "untracked: #{gitstatus_untracked_workaround.join(', ')}"
        puts "added: #{@repo.status.added.keys.join(', ')}"
        puts "changed: #{@repo.status.changed.keys.join(', ')}"
        puts "deleted: #{@repo.status.deleted.keys.join(', ')}"
      end

      sum == 0
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

    def gitstatus_untracked_workaround
      gem_rubygit_buggy_untracked_files = @repo.status.untracked.keys
      git_cmd = "git --work-tree=#{@repo.dir} --git-dir=#{@repo.dir}/.git " +
                "ls-files -z -d -m -o -X .gitignore"
      git_files = `#{git_cmd}`.split("\x0")
      gem_rubygit_buggy_untracked_files & git_files
    end

  end
end

