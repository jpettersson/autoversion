require 'rubygems'
require 'bundler/setup'

require_relative '../lib/autoversion' 
require_relative 'fixtures/versionfiles.rb'

RSpec.configure do |config|
  # some (optional) config here
  config.after(:all) do
    FileUtils.rm_rf File.join(File.dirname(__FILE__), 'tmp', 'gitter')
    FileUtils.rm_rf File.join(File.dirname(__FILE__), 'tmp', 'cli')
  end
end