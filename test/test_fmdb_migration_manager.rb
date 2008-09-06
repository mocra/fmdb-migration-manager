require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  should "have FmdbMigrationManager class" do
    assert OSX::FmdbMigrationManager
  end
  
  context "with clean sqlite db" do
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = OSX::FMDatabase.databaseWithPath @db_path
      @db.open
    end
    
    teardown do
      FileUtils.rm @db_path if File.exists?(@db_path)
    end

    should "create sqlite db" do
      assert File.exists?(@db_path)
    end
  end
  
end