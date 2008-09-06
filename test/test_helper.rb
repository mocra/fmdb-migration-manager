require "test/unit"
require "osx/cocoa"

$:.unshift File.dirname(__FILE__) + "/../build/bundles"
$:.unshift File.dirname(__FILE__) + "/migrations"

require "fileutils"
require "rubygems"
gem 'Shoulda'
require "Shoulda"

class Test::Unit::TestCase
  def self.should_have_no_errors
    should "have no db errors" do
      assert(!@db.hadError?, "Last error (#{@db.lastErrorCode}): #{@db.lastErrorMessage}")
    end
  end
  
  def find_all(table_name)
    @db.executeQuery "select * from #{table_name}"
  end
end
