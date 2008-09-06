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

class Thoughtbot::Shoulda::Context
  def setup_db
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = OSX::FMDatabase.databaseWithPath @db_path
      @db.open
    end
  end

  def teardown_db
    teardown { FileUtils.rm @db_path if File.exists?(@db_path) }
  end
end