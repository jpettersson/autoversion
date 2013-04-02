require 'spec_helper'

describe Autoversion::DSL do

  it "should raise MissingReadBlock unless read_version has defined block" do
    expect {
      @read_blk, @write_blk, @listeners, @config = Autoversion::DSL.evaluate ""
    }.to raise_error(Autoversion::DSL::MissingReadBlock)
  end

  it "should return an empty git config if not defined" do 
    @read_blk, @write_blk, @listeners, @config = Autoversion::DSL.evaluate <<-eof
      read_version do

      end
    eof
  
    @config[:git][:actions].include?(:commit).should == false  
    @config[:git][:actions].include?(:tag).should == false
    @config[:git][:prefix].should == ''
    @config[:git][:stable_branch].should == 'master'
  end

  it "should return a default git config when defined" do 
    @read_blk, @write_blk, @listeners, @config = Autoversion::DSL.evaluate <<-eof
      read_version do

      end

      automate_git
    eof
  
    @config[:git][:actions].include?(:commit).should == true  
    @config[:git][:actions].include?(:tag).should == true
    @config[:git][:prefix].should == ''
    @config[:git][:stable_branch].should == 'master'
  end


  it "should correctly parse git config" do
    @read_blk, @write_blk, @listeners, @config = Autoversion::DSL.evaluate <<-eof
      read_version do

      end

      automate_git :actions => [:commit], :prefix => 'v', :stable_branch => 'dev'
    eof

    @config[:git][:actions].include?(:commit).should == true  
    @config[:git][:actions].include?(:tag).should == false
    @config[:git][:prefix].should == 'v'
    @config[:git][:stable_branch].should == 'dev'
  end

  it "should raise InvalidGitConfig when invalid" do
    expect {
      @read_blk, @write_blk, @listeners, @config = Autoversion::DSL.evaluate <<-eof
        read_version do
          
        end

        automate_git :actions => [:tag]
      eof
    }.to raise_error(Autoversion::DSL::InvalidGitConfig)
  end

end