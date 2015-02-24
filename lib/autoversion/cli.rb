require "thor"

module Autoversion
  class CLI < Thor
    include Thor::Actions

    class << self
      attr_accessor :version_file_contents
      attr_accessor :pwd
    end
    
    def initialize(*args)
      super *args
      version_file_contents = CLI::version_file_contents || File.read(File.join(Dir.pwd, "Versionfile"))
      @versioner = Autoversion::Versioner.new version_file_contents, CLI::pwd
    end

    desc 'read_version', 'Read the Semantic Version of the current project'
    def read_version
      say @versioner.current_version.to_s, :cyan
    end

    desc 'patch', "Increment a patch version"
    method_option :simulate, :type => :boolean, :aliases => "-s"
    method_option :force, :type => :boolean, :aliases => '-f'
    def patch
      increment_version :patch, options[:simulate], options[:force]
    end

    desc 'minor', 'Increment a minor version'
    method_option :simulate, :type => :boolean, :aliases => "-s"
    method_option :force, :type => :boolean, :aliases => '-f'
    def minor
      increment_version :minor, options[:simulate], options[:force]
    end

    desc 'major', 'Increment a major version'
    method_option :simulate, :type => :boolean, :aliases => "-s"
    method_option :force, :type => :boolean, :aliases => '-f'
    def major
      increment_version :major, options[:simulate], options[:force]
    end

    #TODO: Accept arg
    desc 'build', 'Create a build version'
    def special
      create_build_version
    end

    no_tasks do
      def increment_version type, simulate=false, force=false
        if force or yes? "Do you want to increment #{type.to_s} to #{@versioner.next_version(type)}? (y/N)"
          outcome = simulate ? "would change" : "changed"

          begin
            @versioner.increment! type, simulate
            say "Version #{outcome} to #{@versioner.current_version}", simulate ? :cyan : :green
          rescue Autoversion::Gitter::DirtyStaging
            say "Autoversion error: The git workspace is in a dirty state.", :red
          rescue Autoversion::Gitter::NotOnStableBranch => e
            say "Autoversion error: Major version increments can only happen on your configured stable branch (#{e.message}).", :red
          end
        else
          say "No changes were made."
        end
      end
    end

    default_task :read_version
  end
end
