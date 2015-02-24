require 'spec_helper'

describe Autoversion::Versioner do

  before(:each) do
    @path = File.join(File.dirname(__FILE__), 'tmp', 'versioner')
    
    if File.directory? @path
      FileUtils.rm_rf @path
    end

    system("mkdir #{@path}")
    system("tar -xf spec/fixtures/bare_repo.tar --strip 1 -C #{@path}")

    system("echo '0.0.1' > #{@path}/version.txt")
    system("cd #{@path} && git add .")
    system("cd #{@path} && git commit -m 'first'")
    
    @repo = Git.open(@path)

    @versioner = Autoversion::Versioner.new Versionfiles::VALID_BASIC, @path
  end

  it "should be able to read the current version" do
    expect(
      @versioner.current_version.to_s
    ).to eq('1.2.3')
  end

  it "should be able to increment a major version" do
    @versioner.increment! :major

    expect(
      @versioner.current_version.to_s
    ).to eq('2.0.0')
  end

  it "should be able to increment a minor version" do
    @versioner.increment! :minor
    
    expect(
      @versioner.current_version.to_s
    ).to eq('1.3.0')
  end

  it "should be able to increment a patch version" do
    @versioner.increment! :patch
    
    expect(
      @versioner.current_version.to_s
    ).to eq('1.2.4')
  end

  it "should not increment a major if simulate" do
    @versioner.increment! :major, true
    
    expect(
      @versioner.current_version.to_s
    ).to eq('1.2.3')  
  end

  it "should not increment a minor if simulate" do
    @versioner.increment! :minor, true
    
    expect(
      @versioner.current_version.to_s
    ).to eq('1.2.3')
  end

  it "should not increment a patch if simulate" do
    @versioner.increment! :patch, true
    
    expect(
      @versioner.current_version.to_s
    ).to eq('1.2.3')
  end
end