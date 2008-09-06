require "test/unit"
require "osx/cocoa"

$:.unshift File.dirname(__FILE__) + "/../build/bundles"

require "fileutils"
require "rubygems"
gem 'Shoulda'
require "Shoulda"