require File.dirname(__FILE__) + '/test_helper'

require "FmdbMigrationManager.bundle"
OSX::ns_import :FmdbMigrationManager

class TestFmdbMigrationManager < Test::Unit::TestCase
  include OSX
  
  should "have FmdbMigrationManager class" do
    assert FmdbMigrationManager
  end
  
  context "with clean sqlite db" do
    setup do
      @db_path = "/tmp/fmdb-test.db"
      @db = FMDatabase.databaseWithPath @db_path
      @db.open
    end
    
    teardown { FileUtils.rm @db_path if File.exists?(@db_path) }

    should "create sqlite db" do
      assert File.exists?(@db_path)
    end
    
    should_have_no_errors
    
    context "prepare for migrations" do
      setup do
        @migration_manager = FmdbMigrationManager.alloc.initWithDatabase(@db)
      end
      
      should "have migration manager" do
        assert_not_nil(@migration_manager)
        assert_instance_of(OSX::FmdbMigrationManager, @migration_manager)
      end

    end
    
  end
  
end