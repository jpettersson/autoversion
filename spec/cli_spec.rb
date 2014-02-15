require 'spec_helper'
require 'git'
require_relative 'fixtures/versionfiles'

describe Autoversion::CLI do

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
    @path = File.join(File.dirname(__FILE__), 'tmp', 'cli')
    
    if File.directory? @path
      FileUtils.rm_rf @path
    end

    system("mkdir #{@path}")
    system("tar -xf spec/fixtures/bare_repo.tar --strip 1 -C #{@path}")

    system("echo '0.0.1' > #{@path}/version.txt")
    system("cd #{@path} && git add .")
    system("cd #{@path} && git commit -m 'first'")
    
    @repo = Git.open(@path)

    ::Autoversion::CLI.pwd = @path
  end

  it "should be able to read a version" do
    ::Autoversion::CLI.version_file_contents = Versionfiles::BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{} }.join ''
    out.should == "\e[36m0.0.1\e[0m\n"
  end

  it "should be able to write versions" do
    ::Autoversion::CLI.version_file_contents = Versionfiles::BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{patch -f} }.join ''
    out.should == "\e[32mVersion changed to 0.0.2\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{minor -f} }.join ''
    out.should == "\e[32mVersion changed to 0.1.0\e[0m\n"

    out = capture_io{ Autoversion::CLI.start %w{major -f} }.join ''
    out.should == "\e[32mVersion changed to 1.0.0\e[0m\n"
  end

  it "should be able to read/write versions using a pattern matcher" do
    ::Autoversion::CLI.version_file_contents = Versionfiles::PATTERN_VERSIONFILE
    out = capture_io{ Autoversion::CLI.start %w{patch -f} }.join ''
    out.should == "\e[32mVersion changed to 0.0.2\e[0m\n"

    plugin_file = `cd #{@path} && cat lib/your-project/plugins/your-plugin/version.rb`
    ref_file = <<-eof
module YourProject
 VERSION = "0.0.2"
end
eof

    plugin_file.should == ref_file.chop
  end

  it "should be able to write, commit and tag patch" do
    ::Autoversion::CLI.version_file_contents = "automate_git\n\n" + Versionfiles::BASE_VERSIONFILE
    
    out = capture_io{ Autoversion::CLI.start %w{patch -f} }.join ''
    out.should == "\e[32mVersion changed to 0.0.2\e[0m\n"
  end

  it "should be able to write, commit and tag minor" do
    ::Autoversion::CLI.version_file_contents = "automate_git\n\n" + Versionfiles::BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{minor -f} }.join ''
    out.should == "\e[32mVersion changed to 0.1.0\e[0m\n"
  end

  it "should be able to write, commit and tag major" do
    ::Autoversion::CLI.version_file_contents = "automate_git\n\n" + Versionfiles::BASE_VERSIONFILE

    out = capture_io{ Autoversion::CLI.start %w{major -f} }.join ''
    out.should == "\e[32mVersion changed to 1.0.0\e[0m\n"
  end
end