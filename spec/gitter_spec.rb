require 'spec_helper'
require 'git'

describe Autoversion::Gitter do

  before(:each) do
    @gitter_path = File.join(File.dirname(__FILE__), 'tmp', 'gitter')

    if File.directory? @gitter_path
      FileUtils.rm_rf @gitter_path
    end

    system("mkdir #{@gitter_path}")
    system("tar -xf spec/fixtures/bare_repo.tar --strip 1 -C #{@gitter_path}")
    
    system("echo 'test' > #{@gitter_path}/test.txt")
    system("cd #{@gitter_path} && git add .")
    system("cd #{@gitter_path} && git commit -m 'test'")

    @gitter_repo = Git.open(@gitter_path)
  end

  it 'should detect stable branch' do
    @gitter = ::Autoversion::Gitter.new(@gitter_path, {
      :stable_branch => 'master'})

    @gitter_repo.branch('feature1').checkout
    @gitter_repo.branch('feature2').checkout
    @gitter.on_stable_branch?.should eq(false)

    @gitter_repo.branch('master').checkout
    @gitter.on_stable_branch?.should eq(true)
  end

  it 'should be able to commit and tag a new version' do
    @gitter = ::Autoversion::Gitter.new(@gitter_path, {
      :actions => [:commit, :tag], 
      :stable_branch => 'master'})

    #Fake version file
    system("touch #{@gitter_path}/version.rb")

    @gitter.commit! :major, 'v1.2.3'

    @gitter_repo.log.first.message.should == "v1.2.3"
    @gitter_repo.tags.first.name.should == "v1.2.3"
  end

  it 'should should detect cleanliness' do
    @gitter = ::Autoversion::Gitter.new(@gitter_path, {
      :stable_branch => 'master'})

    @gitter.dir_is_clean?.should eq(true)
    system("touch #{@gitter_path}/test2.txt")
    @gitter.dir_is_clean?.should eq(false)
  end

end