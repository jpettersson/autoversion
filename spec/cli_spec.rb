require 'spec_helper'
require 'git'

describe Autoversion::CLI do

  BASE_VERSIONFILE = <<-eos
      read_version do
        File.read File.join(File.dirname(__FILE__), 'spec', 'tmp', 'repo', 'version.txt')
      end

      write_version do |currentVersion, nextVersion|

        # File.open(File.join(File.dirname(__FILE__), 'spec', 'tmp', 'repo', 'version.txt'), 'w') do |file| 
        #   file.write currentVersion.to_s
        # end
      end
    eos

  # Borrowing capture_io from minitest until I have 
  # time to move over to minitest fully.
  def capture_io
    require 'stringio'

    captured_stdout, captured_stderr = StringIO.new, StringIO.new

    Mutex.new.synchronize do
      orig_stdout, orig_stderr = $stdout, $stderr
      $stdout, $stderr         = captured_stdout, captured_stderr

      begin
        yield
      ensure
        $stdout = orig_stdout
        $stderr = orig_stderr
      end
    end

    return captured_stdout.string, captured_stderr.string
  end

  before(:each) do
    @path = File.join(File.dirname(__FILE__), 'tmp', 'repo')
    
    if File.directory? @path
      FileUtils.rm_rf @path
    end

    system("git init #{@path}")
    system("echo '0.0.1' > #{@path}/version.txt")
    system("cd #{@path} && git add .")
    system("cd #{@path} && git commit -m 'first'")
    
    @repo = Git.open(@path)

    @gitter = ::Autoversion::Gitter.new(@path)
  end

  it "should be able to read a version" do
    ::Autoversion::CLI.version_file_contents = BASE_VERSIONFILE
    
    out = capture_io{ Autoversion::CLI.start %w{} }.join ''
    out.should == "\e[36m0.0.1\e[0m\n"
  end

  it "should be able to write versions" do
    ::Autoversion::CLI.version_file_contents = BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{patch -f} }.join ''
    out.should == "\e[32mVersion changed to 0.0.2\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{minor -f} }.join ''
    out.should == "\e[32mVersion changed to 0.1.0\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{major -f} }.join ''
    out.should == "\e[32mVersion changed to 1.0.0\e[0m\n"
  end

  it "should be able to write, commit and tag versions" do
    ::Autoversion::CLI.version_file_contents = "automate_git\n\n" + BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{patch -f} }.join ''
    out.should == "\e[32mVersion changed to 0.0.2\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{minor -f} }.join ''
    out.should == "\e[32mVersion changed to 0.1.0\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{major -f} }.join ''
    out.should == "\e[32mVersion changed to 1.0.0\e[0m\n"
  end

end