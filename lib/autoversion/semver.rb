require 'semantic'

module Autoversion
  class SemVer < ::Semantic::Version

    def increment type
      version = to_a
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

      SemVer.new version.reject{|v| v.nil? }.join '.'
    end

  end
end