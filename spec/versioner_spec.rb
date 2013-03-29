require 'spec_helper'

describe Autoversion::Versioner do

  before(:each) do
    @versioner = Autoversion::Versioner.new Versionfiles::VALID_BASIC
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