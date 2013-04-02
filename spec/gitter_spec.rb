require 'spec_helper'
require 'git'

describe Autoversion::Gitter do

  before(:each) do
    @path = File.join(File.dirname(__FILE__), 'tmp', 'repo')
    
    if File.directory? @path
      FileUtils.rm_rf @path
    end

    system("git init #{@path}")
    system("touch #{@path}/test.txt")
    system("cd #{@path} && git add .")
    system("cd #{@path} && git commit -m 'first'")
    
    @repo = Git.open(@path)
  end

  it 'should should detect cleanliness' do
    @gitter = ::Autoversion::Gitter.new(@path, {
      :stable_branch => 'master'})

    @gitter.dir_is_clean?.should eq(true)
    system("touch #{@path}/test2.txt")
    @gitter.dir_is_clean?.should eq(false)
  end

  it 'should detect stable branch' do
    @gitter = ::Autoversion::Gitter.new(@path, {
      :stable_branch => 'master'})

    @repo.branch('feature1').checkout
    @repo.branch('feature2').checkout
    @gitter.on_stable_branch?.should eq(false)

    @repo.branch('master').checkout
    @gitter.on_stable_branch?.should eq(true)
  end

  it 'should be able to commit and tag a new version' do
    @gitter = ::Autoversion::Gitter.new(@path, {
      :actions => [:commit, :tag], 
      :stable_branch => 'master'})

    #Fake version file
    system("touch #{@path}/version.rb")

    @gitter.commit! :major, 'v1.2.3'

    @repo.log.first.message.should == "v1.2.3"
    @repo.tags.first.name.should == "v1.2.3"
  end

end