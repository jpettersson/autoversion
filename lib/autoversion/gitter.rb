require 'git'

module Autoversion
  class Gitter

    # class DIRTY_STAGING < Exception end
    # class NOT_ON_STABLE_BRANCH < Exception end

    def initialize path, config={}
      @path = path
      @stable_branch = config[:stable] || :master

      @repo = Git.open(path)
    end

    def dir_is_clean?
      @repo.status.untracked.length + @repo.status.added.length + @repo.status.changed.length + @repo.status.deleted.length == 0
    end

    def on_stable_branch?
      @repo.current_branch == @stable_branch.to_s
    end

    def commit! versionType, currentVersion
      # raise DIRTY_STAGING.new unless dir_is_clean?

      # if versionType == :major
      #   raise NOT_ON_STABLE_BRANCH.new unless on_stable_branch?
      # end

      commit_version
      tag_version
    end

    private

    def commit_version

    end

    def tag_version

    end

  end
end