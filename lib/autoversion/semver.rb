require 'semantic'

module Autoversion
  class SemVer < ::Semantic::Version

    def increment type
      version = [0,0,0]
      found = false
      [:major, :minor, :patch].each_with_index do |seg, i|
        if found
          version[i] = 0
        end

        if seg == type
          old = instance_variable_get("@#{seg}")
          version[i] = old+1
          found = true
        end
      end

      SemVer.new version.join '.'
    end

  end
end